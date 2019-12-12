Class {
	#name : #SADefaultAssertionAmplifier,
	#superclass : #SAAbstractAssertionAmplifier,
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> assertionAmplifiedSourceCode [
	| generatedClass observer aMethodAST aVisitor srcv2 srcv3 |
	aMethodAST := RBParser parseMethod: testMethodModel testMethod.
	(MessageCall2Rewriter initializeFor: aMethodAST) doYourJob.
	srcv2 := aMethodAST formattedCode.
	aVisitor := ObserverInsert2Rewriter new.
	aVisitor doYourJob: aMethodAST.
	generatedClass := self buildAuxillaryClass: aMethodAST basedOn: testMethodModel testClass.
	generatedClass suite run.
	3 timesRepeat: [ 
		generatedClass observer resetFlakyDetection.
		generatedClass suite run.
		generatedClass observer checkFlaky ]. "Flaky detection"
	observer := generatedClass observer.
	srcv3 := self insertAsserts: srcv2 using: observer.
	ASTHelper new removeClass: generatedClass source: self class name.
	^ srcv3
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> buildAsserts: anObserver methodName: selector [
	^ anObserver memory
		collect: [ :observation | 
			"self cleanExtraObservations: aMethod"
			| asserts unserializer generateAsserts |
			generateAsserts := true.
			observation
				at: #equalReceiver
				ifPresent: [ :equalReceiver | 
					equalReceiver
						ifTrue: [ generateAsserts := false ] ].
			observation at: #class ifAbsent: [ generateAsserts := false ].
			asserts := OrderedCollection new.
			observation
				at: #exceptionClass
				ifPresent: [ :exceptionClass | 
					asserts := {(ErrorSerializer makeAssertError: exceptionClass)}.
					generateAsserts := false ].
			observation
				at: #timeOutLimit
				ifPresent: [ :timeOutLimit | 
					asserts := {(AbstractSerializer makeAssertTimeOut: timeOutLimit)}.
					generateAsserts := false ].
			generateAsserts
				ifTrue: [ unserializer := SerializerFactory getUnserializer: observation.
					asserts := unserializer
						makeAssertsBasedOnMemory: anObserver memory ].
			asserts
				doWithIndex: [ :assrt :index | 
					assrt arguments
						detect:
							[ :obj | obj class = RBLiteralValueNode and: [ obj value = 'smallAmp' ] ]
						ifFound: [ :obj | 
							obj
								value:
									selector asString , ':' , (observation at: #id) asString , '.'
										, index asString
								start: 0
								stop: -1 ] ].
			(observation at: #id) -> asserts ]
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> buildAuxillaryClass: aMethod basedOn: aClass [
	| generatedClass |
	generatedClass := ASTHelper new
		                  buildTestClassWith: {  }
		                  using: aClass.
	generatedClass class addInstVarNamed: 'observer'.
	generatedClass class compile:
		'observer ^ observer ifNil: [ observer := Observer new ]'.
	generatedClass class compile:
		'testTarget ^ ' , testMethodModel testTargets asString.
	generatedClass class compile: 'isLogging ^true'.
	generatedClass compile: 'observe: anObj name: aString id:anInt 
			       ^ self class observer observe: anObj name: aString id: anInt'.
	generatedClass compile:
		'observeResult: anObj receiver: arec selector: aSelector name: aString id:anInt 
			       ^ self class observer observeResult: anObj receiver: arec selector: aSelector name: aString id: anInt'.
	generatedClass compile: aMethod formattedCode.
	^ generatedClass
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> insertAsserts: aMethodSrc using: anObserver [
	| aMethod newAsserts |
	aMethod := RBParser parseMethod: aMethodSrc.
	newAsserts := self
		buildAsserts: anObserver
		methodName: aMethod selector.
	newAsserts reverse
		do: [ :pair | 
			pair value reverse
				do: [ :assrt | 
					| enclouse |
					enclouse := false.
					assrt selector = #should:raise:description:
						ifTrue: [ enclouse := true ].
					assrt selector = #should:notTakeMoreThan:description:
						ifTrue: [ enclouse := true ].
					assrt selector = #should:takeMoreThan:description:
						ifTrue: [ enclouse := true ].
					enclouse
						ifTrue: [ | msg block |
							msg := aMethod body statements at: pair key.
							block := RBBlockNode body: (RBSequenceNode statements: {msg}).
							"(msg isKindOf: RBAssignmentNode)
								ifTrue: [ msg := (aMethod body statements at: pair key) value ]."
							"(msg isKindOf: RBMessageNode)
								ifTrue: [ "
							assrt arguments at: 1 put: block.
							aMethod body statements at: pair key put: assrt	"] " ]
						ifFalse: [ aMethod body statements add: assrt afterIndex: pair key ] ] ].
	^ aMethod formattedCode
]