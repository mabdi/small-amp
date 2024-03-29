Class {
	#name : #SAGenericMethods,
	#superclass : #Object,
	#classInstVars : [
		'instanceId'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SAGenericMethods class >> defaultPragma [
	^ #madeBySmallAmp
]

{ #category : #'as yet unclassified' }
SAGenericMethods class >> defaultPragmaWithId [

	^ #madeBySmallAmp:
]

{ #category : #'as yet unclassified' }
SAGenericMethods class >> defaultPragmaWithOriginal [

	^ #smallAmpFrom:
]

{ #category : #'as yet unclassified' }
SAGenericMethods class >> instanceId [
	instanceId ifNil: [ instanceId:=0 ].
	instanceId := instanceId + 1.
	^ instanceId
]

{ #category : #'as yet unclassified' }
SAGenericMethods class >> tempPattern [
	^ 'tmp_([a-z0-9A-Z]+)\d+'
]

{ #category : #adding }
SAGenericMethods >> addComment: aText toMethodAST: anAST [
	| newMethodAST |
	(aText includes: $")
		ifTrue: [ newMethodAST := anAST copy.
			newMethodAST statements addFirst: (RBLiteralValueNode value: aText).
			 ]
		ifFalse: [ newMethodAST := self parserClass
				parseMethod: anAST selector , ' "' , aText , '"'.
			newMethodAST replaceNode: newMethodAST body withNode: anAST body.
			newMethodAST
				replaceNode: newMethodAST arguments
				withNode: anAST arguments.
			newMethodAST pragmas: anAST pragmas. ].
		^ newMethodAST
]

{ #category : #adding }
SAGenericMethods >> addHelperMethodsToClass: generatedClass config: config [
	generatedClass class addInstVarNamed: 'modelsCache'.
	generatedClass class addInstVarNamed: 'assertHandler'.
	self
		onClass: generatedClass class
		compile: 'modelsCache ^ modelsCache ifNil: [ modelsCache := Dictionary new ]'.
	self
		onClass: generatedClass class
		compile: 'assertHandler: aHandler assertHandler := aHandler'.
	self
		onClass: generatedClass class
		compile: 'assertHandler ^ assertHandler'.
	self
		onClass: generatedClass class
		compile:
			'addToCache: model self modelsCache at: model selector put: model observedState'.
	self
		onClass: generatedClass class
		compile: 'clearCache modelsCache := nil'.
	self
		onClass: generatedClass
		compile:
			'assertObjectState: anObject varName: aVariableName id: id type: type
			self assert: (self class assertHandler assertObjectState: anObject selector: self selector cache: self class modelsCache varName: aVariableName id: id type: type serializationMaxDepth: '
				, config serializationMaxDepth asString , ')'
]

{ #category : #actions }
SAGenericMethods >> allChangesForRepo: project fromCommitNamed: commitName [
	| repo commit diff leafs targets |
	repo := IceRepository registry detect: [ :x | x name = project ].
	commit := repo commitishNamed: commitName.
	diff := commit diffFromHead.
	leafs := OrderedCollection new.
	diff tree
		allChildrenDo: [ :node | node children ifEmpty: [ leafs add: node ] ].
	leafs := leafs reject: [ :n | n value isRemoval ].
	leafs := leafs select: [ :n | n value definition isMethodDefinition ].
	leafs := leafs
		reject: [ :n | 
			n value definition contextClass isNil
				or: [ n value definition contextClass isTestCase
						or: [ (n value definition contextClass
								includesSelector: n value definition name) not ] ] ].
	targets := leafs
		collect: [ :n | n value definition contextClass >> n value definition name ].
	^ targets
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> allClassesForRepo: repoName [
	Smalltalk
		at: #IceRepository
		ifPresent: [ :clsIceRepository | 
			clsIceRepository registry
				detect: [ :r | r name = repoName ]
				ifFound: [ :r | 
					^ (r workingCopy packages select: [ :p | p isLoaded ])
						flatCollect: [ :p | p package asPackage definedClasses asOrderedCollection ] ] ].
	Smalltalk
		at: #MetacelloProjectRegistration
		ifPresent: [ :clsMetacelloProjectRegistration | 
			| reg |
			reg := clsMetacelloProjectRegistration
				registrationForClassNamed: repoName
				ifAbsent: [ nil ].
			reg
				ifNotNil: [ ^ reg currentlyLoadedClassesInProject asOrderedCollection ] ].
	self error: 'repo not installed. ' , repoName
]

{ #category : #'method operations' }
SAGenericMethods >> buildTestClassAndLogWith: aCollection using: testClass [
	^ self buildTestClassAndLogWith: aCollection  using: testClass asName: (testClass name asString , self getId asString)
			             
]

{ #category : #'method operations' }
SAGenericMethods >> buildTestClassAndLogWith: aCollection using: testClass asName: aName [

	| tempClass |
	tempClass := testClass
		             subclass: (aName) asSymbol
		             instanceVariableNames: ''
		             classVariableNames: ''
		             package: self defaultTempPackage.
	tempClass class compile: self srcAllTestSelectors.
	aCollection do: [ :item | 
		| ast |
		ast := self parsedMethodFrom: item.
		tempClass compile: ast formattedCode ].
	^ tempClass
]

{ #category : #'method operations' }
SAGenericMethods >> buildTestClassAndLogWith: aCollection using: testClass suffix: aSuffix [

	^ self buildTestClassAndLogWith: aCollection using: testClass asName: ('{1}_{2}_{3}' format: {testClass name asString. aSuffix. self getId asString})
]

{ #category : #'method operations' }
SAGenericMethods >> buildTestClassWith: aCollection using: testClass [

	| tempClass |
	tempClass := testClass
		             subclass:
		             (testClass name asString , self getId asString)
			             asSymbol
		             instanceVariableNames: ''
		             classVariableNames: ''
		             package: self defaultTempPackage.
	self onClass: tempClass class compile: self srcAllTestSelectors.
	self onClass: tempClass class compile: self srcDefaultTimeLimit.
	self onClass: tempClass class compile: self srcSmallAmpTargetClasses.
		
	aCollection do: [ :item | 
		| ast |
		ast := self parsedMethodFrom: item.
		self onClass: tempClass compile: ast formattedCode ].
	^ tempClass
]

{ #category : #'method operations' }
SAGenericMethods >> buildTestClassWithModels: aModelsList using: testClass config: config [
	| tempClass |
	tempClass := self
		buildTestClassWith: (aModelsList collect: #testMethod)
		using: testClass.
	self addHelperMethodsToClass: tempClass config: config.
	aModelsList do: [ :x | tempClass
		addToCache: x ]
	.
			
	^ tempClass
]

{ #category : #actions }
SAGenericMethods >> checkOutCommit: commitIdTo inRepo: repoName [

	| repo commit |
	repo := IceRepository registry
		        detect: [ :r | r name = repoName ]
		        ifNone: [ self error: 'repo not found' ].
	commit := repo commitishNamed: commitIdTo.
"commit checkout."
repo setHead: commit
]

{ #category : #cleanup }
SAGenericMethods >> cleanUp: aSourceCode [
	| mtd tmps rewriter |
	mtd := self parsedMethodFrom: aSourceCode.
	tmps := (mtd body temporaries
		select: [ :tmp | tmp name beginsWith: 'tmp_' ])
		reject: [ :tmp | 
			| visitor |
			visitor := SANotUsedTempsVisitor new.
			visitor tmp_var: tmp name.
			mtd acceptVisitor: visitor.
			visitor used ].
	rewriter := RBParseTreeRewriter new.
	tmps
		do: [ :tmp | rewriter replace: tmp name , ' := ``@x' with: '``@x' ].
	rewriter executeTree: mtd.
	tmps do: [ :tmp | mtd body temporaries remove: tmp ].
	^ mtd formattedCode
]

{ #category : #cleanup }
SAGenericMethods >> clearTempClasses [
	<script: 'SAASTHelper new clearTempClasses '>
	(self defaultTempPackage asPackageIfAbsent: [ ^ true ]) classes
		do: [ :item | self removeClass: item source: 'ClearTemp' ]
		displayingProgress: 'Clear temp classes.'
]

{ #category : #actions }
SAGenericMethods >> commitIdFor: repoName [
	| clsIceRepository |
	clsIceRepository := Smalltalk at: #IceRepository ifAbsent: [ nil ].
	clsIceRepository
		ifNotNil: [ ^ clsIceRepository latestCommitIdFor: repoName ]
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> contextInit [

	(CompilationContext includesSelector: #bytecodeBackend) ifTrue: [ 
		CompilationContext bytecodeBackend = EncoderForSistaV1 ifFalse: [ 
			CompilationContext bytecodeBackend: EncoderForSistaV1.
			SmallAmp <~ 'Encoder changed to SistaV1.' ] ].
	Author fullName ifNil: [ 
		Author fullName: 'SmallAmp'.
		SmallAmp <~ 'Author set.' ]
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> createTempPackage [
	(RPackageOrganizer default
		includesPackageNamed: self defaultTempPackage)
		ifFalse: [ RPackageOrganizer default
				createPackageNamed: self defaultTempPackage ].
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> defaultFinalPackage [
	^ 'SmallAmpFinalClasses'
]

{ #category : #'method operations' }
SAGenericMethods >> defaultPragma [
	^ self class defaultPragma
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> defaultTempPackage [
	^ 'SmallAmpTempClasses'
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> disableDeprecationsOn: aClass [
	Deprecation
		activateTransformations: false;
		raiseWarning: false;
		showWarning: false

	"| methods str |
	methods := (Object methodsInProtocol: #deprecation)
		collect: [ :m | m ast copy ].
	methods
		do: [ :m | 
			str := m
				replaceNode: m body
				withNode: (RBSequenceNode statements: #()).
			self onClass: aClass compile: str formattedCode ]"
]

{ #category : #accessing }
SAGenericMethods >> disableDeprecationsWhile: aBlock [
	| activateTransformations raiseWarning showWarning |
	activateTransformations := Deprecation activateTransformations.
	raiseWarning := Deprecation raiseWarning.
	showWarning := Deprecation showWarning.
	^ [ Deprecation
		activateTransformations: false;
		raiseWarning: false;
		showWarning: false.
	aBlock value ]
		ensure: [ Deprecation
				activateTransformations: activateTransformations;
				raiseWarning: raiseWarning;
				showWarning: showWarning ]
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> enableDeprecationsOn: aClass [
	Deprecation
		activateTransformations: true;
		raiseWarning: true;
		showWarning: true
]

{ #category : #accessing }
SAGenericMethods >> extraInformationFor: amplified [
	| json result targetClasses testClass amplifiedClass amplifiedCoverage originalCoverage |
	result := Dictionary new.
	json := STONJSON
		fromString:
			(FileLocator imageDirectory / (amplified , '.json')) asFileReference
				contents.
	targetClasses := (json at: #targetClasses)
		collect: [ :c | self class environment at: c asSymbol ].
	testClass := self class environment at: (json at: #testCase) asSymbol.
	self class environment
		at: (json at: #amplifiedClass) asSymbol
		ifPresent: [ :x | amplifiedClass := x ]
		ifAbsent: [ (FileLocator imageDirectory / ((json at: #amplifiedClass) , '.st'))
				asFileReference fileIn.
			amplifiedClass := self class environment
				at: (json at: #amplifiedClass) asSymbol ].
	amplifiedCoverage := SACoverageAnalyser new
		classes: targetClasses;
		testCases: {amplifiedClass};
		run.
	originalCoverage := SACoverageAnalyser new
		classes: targetClasses;
		testCases: {testClass};
		run.
	self
		safeFail: [ amplifiedCoverage methodsCoverage ]
		key: #amplifiedCoverageMethods
		addTo: result.
	self
		safeFail: [ amplifiedCoverage branchesCoverage ]
		key: #amplifiedCoverageBranches
		addTo: result.
	self
		safeFail: [ amplifiedCoverage statementsCoverage ]
		key: #amplifiedCoverageStatementes
		addTo: result.
	self
		safeFail: [ originalCoverage methodsCoverage ]
		key: #originalCoverageMethods
		addTo: result.
	self
		safeFail: [ originalCoverage branchesCoverage ]
		key: #originalCoverageBranches
		addTo: result.
	self
		safeFail: [ originalCoverage statementsCoverage ]
		key: #originalCoverageStatementes
		addTo: result.
	('Processing ' , amplified) traceCr.
	Smalltalk
		at: #SAReceiverTypeProfiler
		ifPresent: [ :theSAReceiverTypeProfiler | 
			self
				safeFail: [ theSAReceiverTypeProfiler directCallsFor: testClass ]
				key: #directTestingOriginal
				addTo: result ].
	Smalltalk
		at: #SACodeChurnAnalyser
		ifPresent: [ :theSACodeChurnAnalyser | 
			self
				safeFail: [ ((targetClasses
						collect:
							[ :cls | (theSACodeChurnAnalyser new codeChurnForClass: cls) asNumber ])
						inject: 0
						into: [ :accum :each | accum + each ])
						printShowingDecimalPlaces: 2 ]
				key: #targetChurn
				addTo: result.
			self
				safeFail: [ (theSACodeChurnAnalyser new codeChurnForClass: testClass)
						printShowingDecimalPlaces: 2 ]
				key: #testChurn
				addTo: result ].
	Smalltalk
		at: #SATestAssertionDensity
		ifPresent: [ :theSATestAssertionDensity | 
			self
				safeFail: [ theSATestAssertionDensity
						dencityFor: (testClass methods select: #isTestMethod) ]
				key: #assertionDensityOriginal
				addTo: result.
			self
				safeFail: [ theSATestAssertionDensity
						dencityFor:
							(amplifiedClass methods
								select: [ :z | z hasPragmaNamed: SAGenericMethods new defaultPragma ]) ]
				key: #assertionDensityAmplified
				addTo: result ].
	^ result
]

{ #category : #'method operations' }
SAGenericMethods >> extractMethodName: aSourceCode [
	^ (self parsedMethodFrom: aSourceCode) selector
]

{ #category : #private }
SAGenericMethods >> getId [
	^ self class instanceId
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> makeClassFrom: arrayOfTestMethods [
	^ self makeClassFrom: arrayOfTestMethods  instanceVars: '' 
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> makeClassFrom: arrayOfTestMethods instanceVars: instanceVars [
	| cls |
	cls := TestCase
		subclass: ('TempTestClass' , self class instanceId asString) asSymbol
		instanceVariableNames: instanceVars
		classVariableNames: ''
		package: self defaultTempPackage.
	arrayOfTestMethods do: [ :aTestMethod | self onClass: cls compile: aTestMethod ].
	^ cls
]

{ #category : #actions }
SAGenericMethods >> metricsEval: repoName shred: shred seed: aSeed [

	^ self metricsEval: repoName shred: shred seed: aSeed from: nil
]

{ #category : #actions }
SAGenericMethods >> metricsEval: repoName shred: shred seed: aSeed from: aCommitId [

	| classes tests targetedTests testMethodTargeted stat testrun testsuite loc commitId |
	SmallAmp <~ ('Executing metricsEval: {1} shred: {2} seed: {3} from: {4}' format: {repoName. shred. aSeed. aCommitId}).
	aCommitId
		ifNotNil: [ 
			classes := ((self
				             allChangesForRepo: repoName
				             fromCommitNamed: aCommitId) collect: #methodClass)
				           asSet asArray.
			tests := (classes select: #isTestCase) asOrderedCollection.
			self flag: #todo. "use a method in non test classes to relate them to the test class"
			tests addAll:
				(((classes reject: #isTestCase) collect: [ :inputClass | 
					  Smalltalk globals
						  at: ('{1}Test' format: { inputClass name }) asSymbol
						  ifAbsent: [ nil ] ]) reject: #isNil).
			targetedTests := tests select: [ :s | 
				                 s smallAmpTargetClasses isNotNil ] ]
		ifNil: [ 
			classes := self allClassesForRepo: repoName.
			tests := classes select: #isTestCase.
			targetedTests := tests select: [ :s | 
				                 s smallAmpTargetClasses isNotNil ] ].
	commitId := self commitIdFor: repoName.
	loc := (classes collect: #linesOfCode) sum.


	testsuite := TestSuite new.
	targetedTests do: [ :ts | testsuite addTests: ts buildSuite tests ].
	testrun := testsuite run.
	testMethodTargeted := testsuite tests.
	stat := { 
		        (#classes -> classes size).
		        (#tests -> tests size).
		        (#loc -> loc).
		        (#commitId -> commitId).
		        (#targetedTests -> targetedTests size).
		        (#targetedTestsMethods -> testMethodTargeted size).
		        (#allGreen
		         -> (testrun failureCount + testrun errorCount = 0)).
		        (#testsFails -> testrun failureCount).
		        (#testsErrors -> testrun errorCount).
		        (#testsPasses -> testrun passedCount) } asString.
	(FileLocator imageDirectory / (repoName , '.stat')) writeStream
		nextPutAll: stat;
		lf;
		close.
	(FileLocator imageDirectory / 'allTests.txt') writeStream
		nextPutAll: (Character lf join: targetedTests);
		lf;
		close.
	shred > 0 ifTrue: [ 
		targetedTests := self
			                 shredTestClass: targetedTests
			                 max: shred
			                 seed: aSeed.
		targetedTests := targetedTests asOrderedCollection sort: [ :cls1 :cls2 | 
			                 cls1 name asString < cls2 name asString ] ].
	(FileLocator imageDirectory / self todoFile) writeStream
		nextPutAll: (Character lf join: targetedTests);
		lf;
		close.
	^ stat
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> moveClassToFinal: aClass [
	| package |
	(RPackageOrganizer default
		includesPackageNamed: self defaultFinalPackage)
		ifFalse: [ RPackageOrganizer default
				createPackageNamed: self defaultFinalPackage ].
	package := RPackageOrganizer default packageNamed: self defaultFinalPackage.
   package addClass: aClass .
]

{ #category : #'method operations' }
SAGenericMethods >> old_buildTestClassWith: aCollection using: testClass [
	| tempClass package |
	tempClass := testClass
		duplicateClassWithNewName: (testClass name asString , self getId asString) asSymbol.
	(RPackageOrganizer default
		includesPackageNamed: self defaultTempPackage)
		ifFalse: [ RPackageOrganizer default
				createPackageNamed: self defaultTempPackage ].
	package := RPackageOrganizer default
		packageNamed: self defaultTempPackage.
	package addClass: tempClass.
	(testClass methods select: #isTestMethod)
		do: [ :item | tempClass removeSelector: item selector ].
	aCollection
		do: [ :item | 
			| ast |
			ast := self parsedMethodFrom: item.
			tempClass compile: ast formattedCode ].
	^ tempClass
]

{ #category : #compiling }
SAGenericMethods >> onClass: aClass compile: aMethod [
	
	aClass compile: aMethod.
	"SystemAnnouncer uniqueInstance
		suspendAllWhile: [ aClass compile: aMethod ]"
]

{ #category : #compiling }
SAGenericMethods >> onClass: aClass removeSelector: aSelector [
	SystemAnnouncer uniqueInstance
		suspendAllWhile: [ aClass removeSelector: aSelector
			"
			aClass
				compile: aMethod
				classified: Protocol unclassified
				withStamp: nil
				notifying: nil
				logSource: false" ]
]

{ #category : #'method operations' }
SAGenericMethods >> parsedMethodFrom: aSourceCode [
	^ self parserClass parseMethod: aSourceCode
]

{ #category : #factory }
SAGenericMethods >> parserClass [
	^ RBParser
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> performShredingOnTestClass: testClass size: testNumber seed: aSeed [

	| currentTests currentIndex tests result tempClass helpers firstClass upToIndex className |
	currentIndex := 1.
	firstClass := true.
	result := OrderedCollection new.
	tests := testClass testSelectors.
	tests := tests shuffleBy: (Random seed: aSeed).
	helpers := testClass methods reject: [ :m | 
		           tests includes: m selector ].
	[ currentIndex < tests size ] whileTrue: [ 
		upToIndex := currentIndex + testNumber - 1 min: tests size.
		className := (testClass name asString , currentIndex asString
				              , 'To' , upToIndex asString) asSymbol.
		currentTests := tests copyFrom: currentIndex to: upToIndex.
		currentIndex := currentIndex + testNumber.
		currentTests ifEmpty: [ ^ result ].
		tempClass := testClass superclass
			             subclass:
				             className
			             instanceVariableNames:
			             testClass instanceVariablesString
			             classVariableNames: testClass classVariablesString
			             package: self defaultTempPackage.
		testClass class methods do: [ :classSideMethod | 
			tempClass class compile: classSideMethod sourceCode ].
		currentTests do: [ :selector | 
			tempClass compile: (testClass lookupSelector: selector) sourceCode ].
		helpers do: [ :h | tempClass compile: h sourceCode ].
		firstClass ifTrue: [ 
			tempClass class compile: self srcAllTestSelectors.
			firstClass := false ].
		tempClass class compile: self srcDefaultTimeLimit.
		tempClass class compile:
			'smallAmpOriginalTestCase ^ ' , testClass name.
		tempClass class compile:
			'smallAmpTargetClasses ^ self smallAmpOriginalTestCase smallAmpTargetClasses'.
		result add: tempClass ].
	^ result
]

{ #category : #actions }
SAGenericMethods >> preRunChecks [
	CompiledMethod compilerClass compiler compilationContext encoderClass
		= EncoderForSistaV1
		ifFalse: [ Warning new
				signal: 'Change `Bytecode Backend` in setting to `SistaV1`' ].
	
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> randomString [
	| string |
	string := String
		streamContents: [ :stream | 
			Character alphabet putOn: stream.
			Character alphabet asUppercase putOn: stream.
			'0123456789' putOn: stream ].
	^ (String new: 10) collect: [ :each | string atRandom ]
]

{ #category : #removing }
SAGenericMethods >> removeAssertions: aMethod [
	^ (SAAssertTransform
		   removeAllAsserts: (self parsedMethodFrom: aMethod)
		   )
		  formattedCode
]

{ #category : #removing }
SAGenericMethods >> removeClass: theClass source: sid [

	theClass package name = self defaultTempPackage ifFalse: [ 
		
		^ self ].
	theClass removeFromSystem

	"theClass superclass addObsoleteSubclass: theClass.
	theClass environment forgetClass: theClass logged: false.
	theClass obsolete"
]

{ #category : #'method operations' }
SAGenericMethods >> renameAndMoveClass: aClass name: aName package: aPackage [
	(self environment includesKey: aName)
		ifTrue: [^ self error: aName , ' already exists'].
	aClass renameSilently: aName.
	
]

{ #category : #'method operations' }
SAGenericMethods >> renameClass: aClass name: aName [
	aClass rename: aName
]

{ #category : #'method operations' }
SAGenericMethods >> renameMethodName: aSourceCode append: aText [
	| re first |
	re := self parsedMethodFrom: aSourceCode.
	first := (re selector splitOn: $:) at: 1.
	re selector: ((re selector splitOn: $:) at: 1 put: first , aText).
	^ re
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> renameTempVars: anStr [
	^ anStr
		copyWithRegex: self class tempPattern
		matchesTranslatedUsing: [ :each | 'tmp' , (each allButFirst: 14) ]
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> runSafely: aBlock timeOut: aDuration [
	self flag: #todo.	"use  semaphor to be able to kill process"
	^ aBlock
		valueWithin: aDuration
		onTimeout: [ SAUnsafeRunKilled new signal ]
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> runSafelyTestClass: aTestClass selector: aSelector timeOut: aTimeOut [
	^ [ self
		runSafely: [ [ aTestClass run: aSelector ]
				on: Exception
				do: [ :x | 
					x isResumable
						ifTrue: [ x resume ]
						ifFalse: [ ^ nil ] ] ]
		timeOut: aTimeOut ]
		on: SAUnsafeRunKilled
		do: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> runSafelyTestClass: aTestClass timeOut: aTimeOut [
	^ [ self
		runSafely: [ [ aTestClass buildSuite run ]
				on: Exception
				do: [ :x | 
					x isResumable
						ifTrue: [ x resume ]
						ifFalse: [ ^ nil ] ] ]
		timeOut: aTimeOut ]
		on: SAUnsafeRunKilled
		do: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> safeFail: block key: aKey addTo: aDictionary [
	| theValue |
	theValue := block
		on: Error
		do: [ :x | 
			SmallAmp <~ x asString, '-', x messageText
				.
			'N/A' ].
	aDictionary at: aKey put: theValue
]

{ #category : #actions }
SAGenericMethods >> shredTestClass: targetedTests max: maxNum seed: aSeed [

	^ targetedTests flatCollect: [ :cls | 
		  cls allTestSelectors size > maxNum
			  ifTrue: [ 
				  self
					  performShredingOnTestClass: cls
					  size: maxNum
					  seed: aSeed ]
			  ifFalse: [ { cls } ] ]
]

{ #category : #'method operations' }
SAGenericMethods >> signAsSmallAmp: src [
	| ast |
	ast := self parsedMethodFrom: src.
	(ast hasPragmaNamed: self defaultPragma)
		ifFalse: [ ast
				addPragma: (RBPragmaNode selector: self defaultPragma arguments: {}) ].
			^ ast formattedCode 
]

{ #category : #'method operations' }
SAGenericMethods >> signAsSmallAmp: src original: aTestMethod [

	| ast |
	ast := self parsedMethodFrom: src.
	(ast hasPragmaNamed: self class defaultPragmaWithOriginal) ifFalse: [ 
		ast addPragma:
			(RBPragmaNode selector: self class defaultPragmaWithOriginal arguments: { (RBLiteralValueNode value: aTestMethod name )}) ].
	^ ast formattedCode
]

{ #category : #'method operations' }
SAGenericMethods >> srcAllTestSelectors [
	^ 'allTestSelectors
		| answer |
		answer := Set withAll: self testSelectors.
		answer addAll: self superclass allTestSelectors.
		^ answer asSortedCollection asOrderedCollection'
]

{ #category : #'method operations' }
SAGenericMethods >> srcDefaultTimeLimit [
	^ 'defaultTimeLimit
	^ 3 seconds '
]

{ #category : #'method operations' }
SAGenericMethods >> srcSmallAmpTargetClasses [

	^ 'smallAmpTargetClasses
	^ self superclass smallAmpTargetClasses'
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> strip: testMethod [
	| m |
	m := SAAssertTransform
		removeAllAsserts: (self parsedMethodFrom: testMethod).
	
	(m body allChildren allSatisfy: #isSequence 	)
		ifTrue: [ m := SAAssertTransform
				transformAllAsserts: (self parsedMethodFrom: testMethod) ]. "we dont use isEmpty because sometimes we have empty sequences inside body. if all children isSequence we can say all of them are empty"
	^ m formattedCode
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> stripMethodSrc: aMethod [
	^ self stripString: aMethod sourceCode 
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> stripString: aString [ 
	^ aString copyWithoutAll: {Character cr. ' '. Character tab }
]

{ #category : #'as yet unclassified' }
SAGenericMethods >> todoFile [
	^ 'todo.txt'
]
