Class {
	#name : #SAASTHelper,
	#superclass : #Object,
	#classInstVars : [
		'instanceId',
		'unsafeProcess'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SAASTHelper class >> defaultPragma [
	^ #madeBySmallAmp
]

{ #category : #'as yet unclassified' }
SAASTHelper class >> instanceId [
	instanceId ifNil: [ instanceId:=0 ].
	instanceId := instanceId + 1.
	^ instanceId
]

{ #category : #'as yet unclassified' }
SAASTHelper class >> tempPattern [
	^ 'tmp_([a-z0-9A-Z]+)\d+'
]

{ #category : #accessing }
SAASTHelper class >> unsafeProcess [
	^ unsafeProcess ifNil: [ unsafeProcess := [ ] newProcess
		name: 'SmallAmp unsafe run';
		priority: Processor userBackgroundPriority + 1 ]
]

{ #category : #adding }
SAASTHelper >> addComment: aText toMethod: anSRC [
	| newMethodAST anAST |
	anAST := self parserClass parseMethod: anSRC.
	newMethodAST := self addComment: aText  toMethodAST: anAST.
	^ newMethodAST formattedCode
]

{ #category : #adding }
SAASTHelper >> addComment: aText toMethodAST: anAST [
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

{ #category : #'method operations' }
SAASTHelper >> buildTestClassAndLogWith: aCollection using: testClass [
	| tempClass |
	tempClass := testClass
		subclass: (testClass name asString , self getId asString) asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		package: self defaultTempPackage.
	tempClass class
		compile:
			'allTestSelectors
		| answer |
		answer := Set withAll: self testSelectors.
		answer addAll: self superclass allTestSelectors.
		^ answer asSortedCollection asOrderedCollection'.
	aCollection
		do: [ :item | 
			| ast |
			ast := self parsedMethodFrom: item.
			tempClass compile: ast formattedCode ].
	^ tempClass
]

{ #category : #'method operations' }
SAASTHelper >> buildTestClassWith: aCollection using: testClass [
	| tempClass |
	tempClass := testClass
		subclass: (testClass name asString , self getId asString) asSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		package: self defaultTempPackage.
	self
		onClass: tempClass class
		compile:
			'allTestSelectors
		| answer |
		answer := Set withAll: self testSelectors.
		answer addAll: self superclass allTestSelectors.
		^ answer asSortedCollection asOrderedCollection'.
	self
		onClass: tempClass class
		compile:
			'defaultTimeLimit
	^ 3 seconds '.

	aCollection
		do: [ :item | 
			| ast |
			ast := self parsedMethodFrom: item.
			self onClass: tempClass compile: ast formattedCode ].
	^ tempClass
]

{ #category : #cleanup }
SAASTHelper >> cleanUp: aSourceCode [
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
SAASTHelper >> clearTempClasses [
	<script: 'SAASTHelper new clearTempClasses '>
	(self defaultTempPackage asPackageIfAbsent: [ ^ true ]) classes
		do: [ :item | self removeClass: item source: 'ClearTemp' ]
		displayingProgress: 'Clear temp classes.'
]

{ #category : #'as yet unclassified' }
SAASTHelper >> createTempPackage [
	(RPackageOrganizer default
		includesPackageNamed: self defaultTempPackage)
		ifFalse: [ RPackageOrganizer default
				createPackageNamed: self defaultTempPackage ].
]

{ #category : #'as yet unclassified' }
SAASTHelper >> defaultFinalPackage [
	^ 'SmallAmpFinalClasses'
]

{ #category : #'method operations' }
SAASTHelper >> defaultPragma [
	^ self class defaultPragma
]

{ #category : #'as yet unclassified' }
SAASTHelper >> defaultTempPackage [
	^ 'SmallAmpTempClasses'
]

{ #category : #'as yet unclassified' }
SAASTHelper >> disableDeprecationsOn: aClass [
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
SAASTHelper >> disableDeprecationsWhile: aBlock [
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
SAASTHelper >> enableDeprecationsOn: aClass [
	Deprecation
		activateTransformations: true;
		raiseWarning: true;
		showWarning: true
]

{ #category : #'method operations' }
SAASTHelper >> extractMethodName: aSourceCode [
	^ (self parsedMethodFrom: aSourceCode) selector
]

{ #category : #private }
SAASTHelper >> getId [
	^ self class instanceId
]

{ #category : #'as yet unclassified' }
SAASTHelper >> killAllMetalinksOn: aClass [ 
	(aClass   methodDict values do: [ :x | (x ast links select: #isNotNil)do: #uninstall ]).

]

{ #category : #'as yet unclassified' }
SAASTHelper >> makeClassFrom: arrayOfTestMethods [
	^ self makeClassFrom: arrayOfTestMethods  instanceVars: '' 
]

{ #category : #'as yet unclassified' }
SAASTHelper >> makeClassFrom: arrayOfTestMethods instanceVars: instanceVars [
	| cls |
	cls := TestCase
		subclass: ('TempTestClass' , self class instanceId asString) asSymbol
		instanceVariableNames: instanceVars
		classVariableNames: ''
		package: self defaultTempPackage.
	arrayOfTestMethods do: [ :aTestMethod | self onClass: cls compile: aTestMethod ].
	^ cls
]

{ #category : #'as yet unclassified' }
SAASTHelper >> moveClassToFinal: aClass [
	| package |
	(RPackageOrganizer default
		includesPackageNamed: self defaultFinalPackage)
		ifFalse: [ RPackageOrganizer default
				createPackageNamed: self defaultFinalPackage ].
	package := RPackageOrganizer default packageNamed: self defaultFinalPackage.
   package addClass: aClass .
]

{ #category : #'method operations' }
SAASTHelper >> old_buildTestClassWith: aCollection using: testClass [
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
SAASTHelper >> onClass: aClass compile: aMethod [
	SystemAnnouncer uniqueInstance
		suspendAllWhile: [ aClass compile: aMethod.
			"
			aClass
				compile: aMethod
				classified: Protocol unclassified
				withStamp: nil
				notifying: nil
				logSource: false" ]
]

{ #category : #compiling }
SAASTHelper >> onClass: aClass removeSelector: aSelector [
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
SAASTHelper >> parsedMethodFrom: aSourceCode [
	^ self parserClass parseMethod: aSourceCode
]

{ #category : #factory }
SAASTHelper >> parserClass [
	^ RBParser
]

{ #category : #'as yet unclassified' }
SAASTHelper >> randomString [
	| string |
	string := String
		streamContents: [ :stream | 
			Character alphabet putOn: stream.
			Character alphabet asUppercase putOn: stream.
			'0123456789' putOn: stream ].
	^ (String new: 10) collect: [ :each | string atRandom ]
]

{ #category : #removing }
SAASTHelper >> removeAssertions: aMethod [
	^ (SAAssertTransform
		   removeAllAsserts: (self parsedMethodFrom: aMethod)
		   )
		  formattedCode
]

{ #category : #removing }
SAASTHelper >> removeClass: theClass source: sid [
	"theClass removeFromSystem"

	theClass superclass addObsoleteSubclass: theClass.
	theClass environment forgetClass: theClass logged: false.
	theClass obsolete
]

{ #category : #'method operations' }
SAASTHelper >> renameAndMoveClass: aClass name: aName package: aPackage [
	(self environment includesKey: aName)
		ifTrue: [^ self error: aName , ' already exists'].
	aClass renameSilently: aName.
	
]

{ #category : #'method operations' }
SAASTHelper >> renameClass: aClass name: aName [
	aClass rename: aName
]

{ #category : #'method operations' }
SAASTHelper >> renameMethodName: aSourceCode append: aText [
	| re first |
	re := self parsedMethodFrom: aSourceCode.
	first := (re selector splitOn: $:) at: 1.
	re selector: ((re selector splitOn: $:) at: 1 put: first , aText).
	^ re
]

{ #category : #'as yet unclassified' }
SAASTHelper >> renameTempVars: anStr [
	^ anStr
		copyWithRegex: self class tempPattern
		matchesTranslatedUsing: [ :each | 'tmp' , (each allButFirst: 14) ]
]

{ #category : #'as yet unclassified' }
SAASTHelper >> runSafely: aBlock timeOut: aDuration [
	self flag: #todo.	"use  semaphor to be able to kill process"
	^ aBlock
		valueWithin: aDuration
		onTimeout: [ SAUnsafeRunKilled new signal ]
]

{ #category : #'as yet unclassified' }
SAASTHelper >> runSafelyNotWorking: aBlock timeOut: aDuration [
	| retval semaphor p unsafePriority watcherPriority |
	unsafePriority := Processor activeProcess priority - 3.
	watcherPriority := unsafePriority + 1.
	'1' traceCrAt: watcherPriority.
	semaphor := Semaphore new.
	'2' traceCrAt: watcherPriority.
	p := [ '3' traceCrAt: watcherPriority.
	Processor yield.
	retval := aBlock value.
	'4' traceCrAt: watcherPriority.
	semaphor signal.
	'5' traceCrAt: watcherPriority ] newProcess
		name: 'SmallAmp unsafe run';
		priority: unsafePriority.
	'6' traceCrAt: watcherPriority.
	^ [ [ '7' traceCrAt: watcherPriority.
	p resume.
	'8' traceCrAt: watcherPriority.
	semaphor wait.
	'9' traceCrAt: watcherPriority.
	retval ] valueAt: watcherPriority ]
		valueWithin: aDuration
		onTimeout: [ '10' traceCrAt: watcherPriority.
			p terminate.
			SAUnsafeRunKilled new signal ]
]

{ #category : #'as yet unclassified' }
SAASTHelper >> runSafelyTestClass: aTestClass selector: aSelector timeOut: aTimeOut [
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
SAASTHelper >> runSafelyTestClass: aTestClass timeOut: aTimeOut [
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

{ #category : #'method operations' }
SAASTHelper >> signAsSmallAmp: src [
	| ast |
	ast := self parsedMethodFrom: src.
	(ast hasPragmaNamed: self defaultPragma)
		ifFalse: [ ast
				addPragma: (RBPragmaNode selector: self defaultPragma arguments: {}) ].
			^ ast formattedCode 
]

{ #category : #'as yet unclassified' }
SAASTHelper >> strip: testMethod [
	| m |
	m := SAAssertTransform
		removeAllAsserts: (self parsedMethodFrom: testMethod).
	
	(m body allChildren allSatisfy: #isSequence 	)
		ifTrue: [ m := SAAssertTransform
				transformAllAsserts: (self parsedMethodFrom: testMethod) ]. "we dont use isEmpty because sometimes we have empty sequences inside body. if all children isSequence we can say all of them are empty"
	^ m formattedCode
]

{ #category : #'as yet unclassified' }
SAASTHelper >> stripMethodSrc: aMethod [
	^ self stripString: aMethod sourceCode 
]

{ #category : #'as yet unclassified' }
SAASTHelper >> stripString: aString [ 
	^ aString copyWithoutAll: {Character cr. ' '. Character tab }
]
