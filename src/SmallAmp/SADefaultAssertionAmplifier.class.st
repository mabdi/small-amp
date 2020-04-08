Class {
	#name : #SADefaultAssertionAmplifier,
	#superclass : #SAAbstractAssertionAmplifier,
	#instVars : [
		'generatedClass',
		'passingCheckClass'
	],
	#classInstVars : [
		'timing'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #accessing }
SADefaultAssertionAmplifier class >> timing [
	^ timing ifNil: [ timing := SALogger new ]
]

{ #category : #accessing }
SADefaultAssertionAmplifier class >> timing: anObject [ 
	timing:= anObject 
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> amplifyAssertions [
	| aMethodAST sourceCodeWithoutObservers sourceCodeWithAssertions allWindows |
	allWindows := self allOpenedWindows.
	aMethodAST := self astHelper
		parsedMethodFrom: testMethodModel testMethod.
	Stdio stdout
		nextPutAll: 'assert amplification: ' , aMethodAST selector;
		lf;
		flush.
	self class timing
		recoredTag: #normalizeMethod
		toRun: [ self normalizeMethod: aMethodAST ].
	sourceCodeWithoutObservers := aMethodAST formattedCode.
	self class timing
		recoredTag: #insertObservers
		toRun: [ self insertObservers: aMethodAST ].
	self class timing
		recoredTag: #buildANewClassFor
		toRun: [ self
				buildANewClassFor: aMethodAST
				basedOn: testMethodModel testClass ].
	self class timing
		recoredTag: #runTestClass
		toRun: [ self runTestClass ifNil: [ ^ nil ] ].
	self class timing
		recoredTag: #ignoreFlakyValues
		toRun: [ self ignoreFlakyValues ].
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
	self closeAllWindowsBut: allWindows.
	^ sourceCodeWithAssertions
]

{ #category : #asserting }
SADefaultAssertionAmplifier >> assertBuilder [
	^ SAAssertGenerator new
]

{ #category : #accessing }
SADefaultAssertionAmplifier >> astHelper [
	^ SAASTHelper new
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> buildANewClassFor: aMethod basedOn: aClass [
	generatedClass
		ifNil: [ generatedClass := self astHelper
				buildTestClassWith: {}
				using: aClass.
			generatedClass class addInstVarNamed: 'observer'.
			generatedClass class
				compile:
					'observer ^ observer ifNil: [ observer := SAObserver newForTarget: '
						, testMethodModel testTargets asString , ' ]'.
					generatedClass class
				compile:
					'observerReset  observer := nil ' ].
	generatedClass observerReset.
	generatedClass compile: aMethod formattedCode.
	^ generatedClass
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> buildAsserts: anObserver methodName: selector [
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
SADefaultAssertionAmplifier >> checkPassing: sourceCodeWithAssertions [
	| r allWindows |
	passingCheckClass
		ifNil: [ passingCheckClass := self astHelper
				buildTestClassWith: {sourceCodeWithAssertions}
				using: testMethodModel testClass ]
		ifNotNil: [ passingCheckClass compile: sourceCodeWithAssertions ].
	allWindows := self allOpenedWindows.
	r := [ (passingCheckClass run: testMethodModel selector) hasPassed ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ false ].
	self closeAllWindowsBut: allWindows.
	r
		ifFalse: [ self
				log4debug: #AssertAmplifyCheckPassing
				what: sourceCodeWithAssertions ].
	^ r
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> cleanUp [
	config debug
		ifTrue: [ ^ self ].
	generatedClass removeSelector: testMethodModel selector.	"self astHelper removeClass: generatedClass source: self class name"
]

{ #category : #cleanup }
SADefaultAssertionAmplifier >> cleanUp: generatedClass [
	config debug ifFalse: [ 
		self astHelper removeClass: generatedClass source: self class name ]
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> flackyTestRepeat [
	^ config flackyTestRepeat
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> ignoreFlakyValues [
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
SADefaultAssertionAmplifier >> insertAsserts: aMethodSrc using: anObserver [
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
SADefaultAssertionAmplifier >> insertObservers: aMethodAST [
	SAObserverInsertingRewriter new config: config; methodAST: aMethodAST; run
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> log4debug: tag what: obj [
	SALogger debugWatchings
				add: tag -> obj
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> normalizeMethod: aMethodAST [
	SAMethodNormalizingRewriter runWith: aMethodAST
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> runTestClass [
	^ [ generatedClass run: testMethodModel selector ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ nil ]
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> validFlakyMem [
	[ generatedClass observer history
		with: generatedClass observer flakyMem
		do: [ :a :b | 
			a class = b class
				ifFalse: [ ^ false ] ] ]
		on: Error
		do: [ ^ false ].
		^ true
]
