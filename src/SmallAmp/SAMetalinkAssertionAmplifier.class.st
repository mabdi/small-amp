Class {
	#name : #SAMetalinkAssertionAmplifier,
	#superclass : #SAAbstractAssertionAmplifier,
	#instVars : [
		'generatedClass',
		'passingCheckClass',
		'links'
	],
	#classInstVars : [
		'timing'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #accessing }
SAMetalinkAssertionAmplifier class >> timing [
	^ timing ifNil: [ timing := SALogger new ]
]

{ #category : #accessing }
SAMetalinkAssertionAmplifier class >> timing: anObject [ 
	timing:= anObject 
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> amplifyAssertions [
	| aMethodAST sourceCodeWithoutObservers sourceCodeWithAssertions |
	links := OrderedCollection new.
	aMethodAST := self astHelper
		parsedMethodFrom: testMethodModel testMethod.
	Stdio stdout
		nextPutAll: 'assert amplification: ';
		nextPutAll: aMethodAST selector;
		lf;
		flush.
	self class timing
		recoredTag: #normalizeMethod
		toRun: [ self normalizeMethod: aMethodAST ].
	sourceCodeWithoutObservers := aMethodAST formattedCode.
	self class timing
		recoredTag: #buildANewClassFor
		toRun: [ self
				buildANewClassFor: aMethodAST
				basedOn: testMethodModel testClass ].
	self class timing
		recoredTag: #installMetalinks
		toRun: [ self installMetalinks ].
	self class timing
		recoredTag: #runTestClass
		toRun: [ self runTestClass ifNil: [ ^ nil ] ].
	self class timing
		recoredTag: #ignoreFlakyValues
		toRun: [ self ignoreFlakyValues ].
	self uninstallLinks.
	self class timing
		recoredTag: #insertAsserts
		toRun: [ sourceCodeWithAssertions := self
				insertAsserts: sourceCodeWithoutObservers
				using: generatedClass observer ].
	self class timing
		recoredTag: #checkPassing
		toRun: [ (self checkPassing: sourceCodeWithAssertions)
				ifFalse: [ ^ nil ] ].
	self class timing recoredTag: #cleanUp toRun: [ self cleanUp ].
	^ sourceCodeWithAssertions
]

{ #category : #asserting }
SAMetalinkAssertionAmplifier >> assertBuilder [
	^ SAAssertGenerator new
]

{ #category : #accessing }
SAMetalinkAssertionAmplifier >> astHelper [
	^ SAASTHelper new
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> buildANewClassFor: aMethod basedOn: aClass [
	generatedClass
		ifNil: [ generatedClass := self astHelper
				buildTestClassWith: {}
				using: aClass.
			generatedClass class addInstVarNamed: 'observer'.
			generatedClass class
				compile:
					'observer ^ observer ifNil: [ observer := SAObserver newForTarget: '
						, testMethodModel testTargets asString , ' serialDepth: '
						, config serializationMaxDepth asString , ' ]'.
			generatedClass class compile: 'observerReset  observer := nil ' ].
	generatedClass observerReset.
	generatedClass compile: aMethod formattedCode.
	^ generatedClass
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> buildAsserts: anObserver methodName: selector [
	^ anObserver history collect: [ :observation | 
		  | asserts |
		  asserts := observation buildAssertions: self assertBuilder.
		  asserts doWithIndex: [ :assrt :index | 
			  assrt arguments
				  detect: [ :obj | 
					  obj class = RBLiteralValueNode and: [ obj value = 'smallAmp' ] ]
				  ifFound: [ :obj | 
					  obj
						  value:
							  selector asString , ':' , observation id asString , '.'
							  , index asString
						  start: 0
						  stop: -1 ] ].
		  observation id -> asserts ]
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> checkPassing: sourceCodeWithAssertions [
	| r allWindows |
	"passingCheckClass
		ifNil: [ passingCheckClass := self astHelper
				buildTestClassWith: {sourceCodeWithAssertions}
				using: testMethodModel testClass ]
		ifNotNil: [ passingCheckClass compile: sourceCodeWithAssertions ]."
	"self class timing
		recoredTag: #checkPassingAllOpen
		toRun: [ allWindows := self allOpenedWindows ]."
	self class timing
		recoredTag: #checkPassingCompile
		toRun: [ generatedClass compile: sourceCodeWithAssertions ].
	self class timing
		recoredTag: #checkPassingHasPassed
		toRun: [ r := [ [ (generatedClass run: testMethodModel selector) hasPassed ]
				on: Exception
				do: [ :x | 
					x isResumable
						ifTrue: [ x resume ]
						ifFalse: [ false ] ] ]
				valueWithin: (config testRunTimeOutMult * testRunTimeoutMillis) milliSeconds
				onTimeout: [ false ] ].
	"self class timing
		recoredTag: #checkPassingCloseAll
		toRun: [ self closeAllWindowsBut: allWindows ]."
	r
		ifFalse: [ self class timing
				recoredTag: #checkPassingLoggin
				toRun: [ self
						log4debug: #AssertAmplifyCheckPassing
						what: sourceCodeWithAssertions ] ].
	^ r
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> cleanUp [
	config debug
		ifTrue: [ ^ self ].
	generatedClass removeSelector: testMethodModel selector.	"self astHelper removeClass: generatedClass source: self class name"
]

{ #category : #cleanup }
SAMetalinkAssertionAmplifier >> cleanUp: generatedClass [
	config debug ifFalse: [ 
		self astHelper removeClass: generatedClass source: self class name ]
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> flackyTestRepeat [
	^ config flackyTestRepeat
]

{ #category : #accessing }
SAMetalinkAssertionAmplifier >> generatedClass [
	^ generatedClass
]

{ #category : #accessing }
SAMetalinkAssertionAmplifier >> generatedClass: anObject [
	generatedClass := anObject
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> ignoreFlakyValues [
	self flackyTestRepeat
		timesRepeat: [ "Flaky detection"
			generatedClass observer resetFlakyDetection.
			self runTestClass
				ifNil: [ self
						log4debug: #ignoreFlakyValues
						what: (generatedClass methodNamed: testMethodModel selector) sourceCode.
					^ self ].
			self validFlakyMem ifTrue: [generatedClass observer checkFlaky].
			
			 ]
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> insertAsserts: aMethodSrc using: anObserver [
	| aMethod newAsserts |
	aMethod := self astHelper parsedMethodFrom: aMethodSrc.
	newAsserts := self
		buildAsserts: anObserver
		methodName: aMethod selector.
	newAsserts ifEmpty: [ ^ aMethod formattedCode ].
	[ newAsserts last key < aMethod statements size ]
		whileTrue: [ aMethod statements removeLast ].
	newAsserts reverse
		do: [ :pair | 
			pair value reverse
				do: [ :assrt | 
					| enclouse |
					enclouse := false.
					(assrt arguments at: 1) isVariable
						ifTrue: [ (assrt arguments at: 1) name = SAAssertGenerator blockPlaceHolder
								ifTrue: [ enclouse := true ] ].
					enclouse
						ifTrue: [ | msg block |
							msg := aMethod body statements at: pair key.
							block := RBBlockNode body: (RBSequenceNode statements: {msg}).
							assrt arguments at: 1 put: block.
							aMethod body statements at: pair key put: assrt	"] " ]
						ifFalse: [ aMethod body statements add: assrt afterIndex: pair key ] ] ].
	^ aMethod formattedCode
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> installLinkOnSend: statement index: index [
	| link |
	link := MetaLink new
		metaObject: self;
		control: #before;
		selector: #wrapTheMethodNode:args:receiver:selector:;
		arguments: #(node arguments receiver selector);
		yourself.
	links add: link.
	
	statement link: link.
	self halt.
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> installMetalinks [
	| statements |
	statements := (generatedClass >> testMethodModel selector) ast
		statements.
	statements
		doWithIndex: [ :statement :index | 
			statement isAssignment
				ifTrue: [ statement value isMessage
						ifTrue: [ self installLinkOnSend: statement value index: index ] ] ]
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> log4debug: tag what: obj [
	SALogger debugWatchings
				add: tag -> obj
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> normalizeMethod: aMethodAST [
	SAMethodNormalizingRewriter runWith: aMethodAST
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> runTestClass [
	"If test throws any Exception, most probabily it's a malformed test. don't waste your time with it"

	^ [ [ generatedClass run: testMethodModel selector ]
		on: Exception
		do: [ :x | x isResumable
				ifTrue: [ x resume ]
				ifFalse: [ nil ] ] ]
		valueWithin: (config testRunTimeOutMult * testRunTimeoutMillis) milliSeconds
		onTimeout: [ nil ]
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> uninstallLinks [
	links do: #uninstall.
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> validFlakyMem [
	[ generatedClass observer history
		with: generatedClass observer flakyMem
		do: [ :a :b | 
			a class = b class
				ifFalse: [ ^ false ] ] ]
		on: Error
		do: [ ^ false ].
		^ true
]

{ #category : #'as yet unclassified' }
SAMetalinkAssertionAmplifier >> wrapTheMethodNode: node args: arg receiver: receiver selector: selector [
	self halt.
]
