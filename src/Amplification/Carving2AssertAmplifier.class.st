Class {
	#name : #Carving2AssertAmplifier,
	#superclass : #AbstractAssertAmplifier,
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
Carving2AssertAmplifier >> buildAsserts: anObserver methodName: selector [
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
								value: selector asString , ':' , (observation at: #id) asString , '.' , index asString
								start: 0
								stop: -1 ] ].
			(observation at: #id) -> asserts ]
]

{ #category : #'as yet unclassified' }
Carving2AssertAmplifier >> buildAxularyClass: aMethod basedOn: aClass [
	| generatedClass |
	generatedClass := ASTHelper uniqueInstance
		buildAnTestClassWith: {}
		using: aClass.
	generatedClass class addInstVarNamed: 'observer'.
	generatedClass class
		compile: 'observer ^ observer ifNil: [ observer := Observer new ]'.
	generatedClass class compile: 'isLogging ^true'.
	generatedClass
		compile:
			'observe: anObj name: aString id:anInt 
			       ^ self class observer observe: anObj name: aString id: anInt'.
	generatedClass
		compile:
			'observeResult: anObj receiver: arec selector: aSelector name: aString id:anInt 
			       ^ self class observer observeResult: anObj receiver: arec selector: aSelector name: aString id: anInt'.
	generatedClass compile: aMethod formattedCode.
	^ generatedClass
]

{ #category : #'as yet unclassified' }
Carving2AssertAmplifier >> doAssertionAmplification: aMethodSrc within: aClass [
	| generatedClass observer aMethod aVisitor src2 src3 |
	aMethod := RBParser parseMethod: aMethodSrc.
	aVisitor := MessageCallRewriter new.
	aVisitor doYourJob: aMethod.
	src2 := aMethod formattedCode.
	aVisitor := ObserverInsert2Rewriter new.
	aVisitor doYourJob: aMethod.
	generatedClass := self buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	src3 := self insertAsserts: src2 using: observer.
	ASTHelper uniqueInstance removeClass: generatedClass source: self class name.
	^ src3
]

{ #category : #'as yet unclassified' }
Carving2AssertAmplifier >> insertAsserts: aMethodSrc using: anObserver [
	| aMethod newAsserts |
	aMethod := RBParser parseMethod: aMethodSrc.
	newAsserts := self
		buildAsserts: anObserver
		methodName: aMethod selector.
		
	newAsserts reverse
		do: [ :pair | 
			pair value reverse
				do: [ :assrt | 
					assrt selector = #should:raise:description:
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
