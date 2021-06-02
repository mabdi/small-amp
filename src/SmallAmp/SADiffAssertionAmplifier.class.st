Class {
	#name : #SADiffAssertionAmplifier,
	#superclass : #SAAbstractAssertionAmplifier,
	#instVars : [
		'generatedClass',
		'passingCheckClass'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> amplifyAssertions [
	| aMethodAST sourceCodeWithoutObservers sourceCodeWithAssertions |
	aMethodAST := self astHelper
		parsedMethodFrom: testMethodModel testMethod.
	self normalizeMethod: aMethodAST.
	sourceCodeWithoutObservers := aMethodAST formattedCode.
	self insertObservers: aMethodAST.
	self buildANewClassFor: aMethodAST basedOn: testMethodModel testClass.
	self runTestClass ifNil: [ ^ nil ].
	self ignoreFlakyValues.
	testMethodModel observedState: generatedClass observer history.
	sourceCodeWithAssertions := self
		insertAsserts: sourceCodeWithoutObservers
		using: generatedClass observer.
	(self checkPassing: sourceCodeWithAssertions)
		ifFalse: [ ^ nil ].
	self cleanUp.
	^ sourceCodeWithAssertions
]

{ #category : #asserting }
SADiffAssertionAmplifier >> assertObjectState: anObject selector: selector cache: modelsCache varName: aVariableName id: id type: type serializationMaxDepth: serializationMaxDepth [
		| history item |
	history := (modelsCache at: selector)
		detect: [ :x | x id = id and: [ x observedBy = type ] ].
	item := anObject
		smallAmpAcceptSerializerVisitor: (SAStateSerializer withDepth: serializationMaxDepth)
		atDepth: 0.
	item
		name: aVariableName;
		id: id.
	^ history isEquals: item
]

{ #category : #accessing }
SADiffAssertionAmplifier >> astHelper [
	^ SAGenericMethods new
]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> buildANewClassFor: aMethod basedOn: aClass [
	generatedClass
		ifNil: [ generatedClass := self astHelper
				buildTestClassWithModels: {}
				using: aClass
				config: config.
			generatedClass assertHandler: self.
			SystemAnnouncer uniqueInstance
				suspendAllWhile: [ generatedClass class addInstVarNamed: 'observer' ].
			self astHelper
				onClass: generatedClass class
				compile:
					'observer ^ observer ifNil: [ observer := SAObserver newForTarget: '
						, testMethodModel testTargets asString , ' serialDepth: '
						, config serializationMaxDepth asString , ' ]'.
			self astHelper
				onClass: generatedClass class
				compile: 'observerReset  observer := nil ' ].
	generatedClass observerReset.
	self astHelper onClass: generatedClass compile: aMethod formattedCode.
	^ generatedClass
]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> buildAsserts: anObserver methodName: selector [
	^ anObserver history
		collect: [ :observation | 
			| asserts |
			asserts := observation noHashAsserts
				ifTrue: [ observation buildAssertions: SAAssertGenerator new ]
				ifFalse:
					[ {(SAAssertGenerator new buildAssertObjectStateFor: observation )} ].
						asserts
				doWithIndex: [ :assrt :index | 
					assrt arguments
						detect:
							[ :obj | obj class = RBLiteralValueNode and: [ obj value = 'smallAmp' ] ]
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
SADiffAssertionAmplifier >> checkPassing: sourceCodeWithAssertions [
	| r |
	self astHelper
		onClass: generatedClass
		compile: sourceCodeWithAssertions.
	generatedClass addToCache: testMethodModel.
	r := SAGenericMethods new
		runSafelyTestClass: generatedClass
		selector: testMethodModel selector
		timeOut: (config testRunTimeOutMult * testRunTimeoutMillis) milliSeconds.
	r ifNil: [ ^ false ].
	^ r hasPassed
]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> cleanUp [
	config debug
		ifTrue: [ ^ self ].
	self astHelper
		onClass: generatedClass
		removeSelector: testMethodModel selector	"self astHelper removeClass: generatedClass source: self class name".
	generatedClass clearCache
]

{ #category : #cleanup }
SADiffAssertionAmplifier >> cleanUp: generatedClass [
	config debug ifFalse: [ 
		self astHelper removeClass: generatedClass source: self class name ]
]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> flackyTestRepeat [
	^ config flackyTestRepeat
]

{ #category : #accessing }
SADiffAssertionAmplifier >> generatedClass [
	^ generatedClass
]

{ #category : #accessing }
SADiffAssertionAmplifier >> generatedClass: anObject [
	generatedClass := anObject
]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> ignoreFlakyValues [
	self flackyTestRepeat
		timesRepeat: [ "Flaky detection"
			generatedClass observer resetFlakyDetection.
			self runTestClass
				ifNil: [ 					^ self ].
			self validFlakyMem
				ifTrue: [ generatedClass observer checkFlaky ] ]
]

{ #category : #initialization }
SADiffAssertionAmplifier >> initialize [
]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> insertAsserts: aMethodSrc using: anObserver [
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
SADiffAssertionAmplifier >> insertObservers: aMethodAST [
	| targetNodes |
	targetNodes := aMethodAST statements select: #isAssignment.
	targetNodes do: [ :theNode | self insertObserversMethod: aMethodAST Node: theNode ]
]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> insertObserversMethod: methodAST Node: theNode [
	| aNode idx theReceiver theSelector a b |
	aNode := theNode nodesDo: [ :each | each comments: nil ].
	idx := methodAST body statements indexOf: aNode.
	theReceiver := nil.
	theSelector := nil.
	aNode value class = RBCascadeNode
		ifTrue: [ theReceiver := (aNode value messages at: 1) receiver.
			theSelector := aNode value messages last selector ].
	aNode value class = RBMessageNode
		ifTrue: [ theReceiver := aNode value receiver.
			theSelector := aNode value selector ].
	theReceiver
		ifNotNil: [ theReceiver isVariable
				ifTrue: [ a := RBParser
						parseExpression:
							'[]
		on: Error
		do: [ :ex | 
			self class observer observeException: ex id: ' , idx asString
								, '. ^ self ]'.
					b := RBParser
						parseExpression:
							'[|smallamp_elapsedTime noObserve| noObserve:=false. smallamp_elapsedTime := Time
		millisecondsToRun: [ [ ' , aNode formattedCode
								,
									' ]
		valueWithin: ' , config statementTimeOut asString
								,
									' milliSeconds
		onTimeout: [ self class observer observeTimeOut: '
								, config statementTimeOut asString , ' id: ' , idx asString
								,
									'. noObserve:=true  ] ].
	noObserve ifFalse: [ [self class observer observe: '
								, theReceiver formattedCode , ' name: '''
								, theReceiver formattedCode , ''' id: ' , idx asString
								,
									'.
	self class observer observeResult: ' , aNode variable name
								,
									'
		receiver: ' , theReceiver formattedCode
								,
									'
		selector: #' , theSelector asString
								,
									'
		name: #' , aNode variable name
								,
									'
		id: ' , idx asString
								, ' ] on: Error do: [ :saERR | self error: ''checkMe'' ] ] ]'.
					a receiver: b.
					methodAST body statements at: idx put: a ] ]
]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> normalizeMethod: aMethodAST [
	SAMethodNormalizingRewriter runWith: aMethodAST
]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> runTestClass [
	"If test throws any Exception, most probabily it's a malformed test. don't waste your time with it"
	^ SAGenericMethods new
		runSafelyTestClass: generatedClass
		selector: testMethodModel selector
		timeOut: (config testRunTimeOutMult * testRunTimeoutMillis) milliSeconds
		

]

{ #category : #'as yet unclassified' }
SADiffAssertionAmplifier >> validFlakyMem [
	[ generatedClass observer history
		with: generatedClass observer flakyMem
		do: [ :a :b | 
			a class = b class
				ifFalse: [ ^ false ] ] ]
		on: Error
		do: [ ^ false ].
		^ true
]
