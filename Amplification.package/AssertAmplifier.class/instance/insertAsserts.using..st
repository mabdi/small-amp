as yet unclassified
insertAsserts: aMethod using: anObserver
	anObserver memory 
		do: [ :observation | 
			| asserts unserializer |
			unserializer := SerializerFactory getUnserializer: observation.
			asserts := unserializer makeAssertsBasedOnMemory: anObserver memory.
			self insertAssertions: asserts in: aMethod on: observation ]