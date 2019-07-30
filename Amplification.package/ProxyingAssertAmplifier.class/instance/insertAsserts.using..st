as yet unclassified
insertAsserts: aMethodSrc using: anObserver
	| aMethod newAsserts |
	newAsserts := anObserver memory
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
			generateAsserts
				ifTrue: [ unserializer := SerializerFactory getUnserializer: observation.
					asserts := unserializer
						makeAssertsBasedOnMemory: anObserver memory ].
			(observation at: #id) -> asserts ].
	aMethod := RBParser parseMethod: aMethodSrc.
	newAsserts reverse
		do: [ :pair | 
			pair value reverse
				do: [ :assrt | aMethod body statements add: assrt afterIndex: pair key ] ].
	^ aMethod formattedCode