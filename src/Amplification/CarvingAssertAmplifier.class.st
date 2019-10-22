Class {
	#name : #CarvingAssertAmplifier,
	#superclass : #AbstractAssertAmplifier,
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
CarvingAssertAmplifier >> buildAxularyClass: aMethod basedOn: aClass [
	| generatedClass |
	generatedClass := ASTHelper uniqueInstance
		buildAnTestClassWith: {}
		using: aClass.
	generatedClass class addInstVarNamed: 'observer'.
	generatedClass class
		compile: 'observer ^ observer ifNil: [ observer := Observer new ]'.
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
CarvingAssertAmplifier >> cleanExtraObservations: aMethod [
	(aMethod body statements
		select: [ :item | self isObservationPoint: item ]) do: [ :item | aMethod body statements remove: item ]
]

{ #category : #'as yet unclassified' }
CarvingAssertAmplifier >> doAssertionAmplification: aMethodSrc within: aClass [
	| generatedClass observer aMethod |
	aMethod := RBParser parseMethod: aMethodSrc.
	self insertObservers: aMethod.
	generatedClass := self buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	self insertAsserts: aMethod using: observer.
	ASTHelper uniqueInstance removeClass: generatedClass source: self class name..
	^ aMethod formattedCode
]

{ #category : #'as yet unclassified' }
CarvingAssertAmplifier >> findObservationPoint: item id: id [
	(item isKindOf: RBMessageNode)
		ifFalse: [ ^ false ].
	(item selector = #observe:name:id:
		and: [ (item arguments at: 3) value = id ])
		ifTrue: [ ^ true ].
	(item selector = #observeResult:receiver:selector:name:id:
		and: [ (item arguments at: 5) value = id ])
		ifTrue: [ ^ true ].
	^ false
]

{ #category : #'as yet unclassified' }
CarvingAssertAmplifier >> insertAssertions: asserts in: aMethod on: observation [
	aMethod body statements
		detect: [ :item | self findObservationPoint: item id: (observation at: #id) ]
		ifFound: [ :item | 
			| idx |
			idx := aMethod body statements indexOf: item.
			asserts
				do: [ :assert | aMethod body statements add: assert afterIndex: idx ].
			aMethod body statements remove: item ]
]

{ #category : #'as yet unclassified' }
CarvingAssertAmplifier >> insertAsserts: aMethod using: anObserver [
	anObserver memory
		do: [ :observation | 
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
			
			generateAsserts
				ifTrue: [ unserializer := SerializerFactory getUnserializer: observation.
					asserts := unserializer
						makeAssertsBasedOnMemory: anObserver memory ].
			self insertAssertions: asserts in: aMethod on: observation ]
]

{ #category : #'as yet unclassified' }
CarvingAssertAmplifier >> insertObservers: aMethod [
	| aVisitor |
	aVisitor := MessageCallRewriter new.
	aVisitor doYourJob: aMethod.
	aVisitor := ObserverInsertRewriter new.
	aVisitor doYourJob: aMethod.
	
]

{ #category : #'as yet unclassified' }
CarvingAssertAmplifier >> isObservationPoint: item [
	(item isKindOf: RBMessageNode)
		ifFalse: [ ^ false ].
	item selector = #observe:name:id:
		ifTrue: [ ^ true ].
	item selector = #observeResult:receiver:selector:name:id:
		ifTrue: [ ^ true ].
	^ false
]
