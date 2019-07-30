as yet unclassified
insertAsserts: aMethod using: anObserver
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