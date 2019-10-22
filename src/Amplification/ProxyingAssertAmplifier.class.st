Class {
	#name : #ProxyingAssertAmplifier,
	#superclass : #AbstractAssertAmplifier,
	#instVars : [
		'targets'
	],
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
ProxyingAssertAmplifier >> buildAsserts: anObserver [
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
			(observation at: #id) -> asserts ]
]

{ #category : #'as yet unclassified' }
ProxyingAssertAmplifier >> doAssertAmplification: population amplifier: anAmplifier [
	self targets: anAmplifier targetClasses.
	^ super doAssertAmplification: population amplifier: anAmplifier
]

{ #category : #'as yet unclassified' }
ProxyingAssertAmplifier >> doAssertionAmplification: aMethodSrc within: aClass [
	| generatedClass observer proxies |
	observer := Observer new.
	generatedClass := ASTHelper uniqueInstance
		buildAnTestClassWith: {}
		using: aClass.
	generatedClass compile: aMethodSrc.
	proxies := self methodsToBeProxied
		collect:
			[ :mtd | ObservationProxy for: mtd observer: observer inside: generatedClass ].
	[ generatedClass suite run ]
		ensure: [ proxies do: [ :mtd | mtd destroy ] ].
	ASTHelper uniqueInstance removeClass: generatedClass  source: self class name..
	^ self insertAsserts: aMethodSrc using: observer
]

{ #category : #'as yet unclassified' }
ProxyingAssertAmplifier >> insertAsserts: aMethodSrc using: anObserver [
	| aMethod newAsserts |
	newAsserts := self buildAsserts: anObserver.
	aMethod := RBParser parseMethod: aMethodSrc.
	newAsserts reverse
		do: [ :pair | 
			pair value reverse
				do: [ :assrt | 
					assrt selector = #should:raise:
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

{ #category : #'as yet unclassified' }
ProxyingAssertAmplifier >> methodsToBeProxied [
	| result |
	result := OrderedCollection new.
	targets
		do: [ :aTarget | 
			result
				addAll:
					((Pragma allNamed: #SmallAmpAction in: aTarget)
						collect: [ :pragma | pragma method ]) ].
	result ifNotEmpty: [ ^ result ].
	targets
		do: [ :aTarget | 
			result addAll: (aTarget methods reject: [ :mtd | ({ #initialization . #private} indexOf: mtd protocol) > 0 ])
			
			 ].
	^ result
]

{ #category : #accessing }
ProxyingAssertAmplifier >> targets: someTargets [
targets := someTargets 
]
