as yet unclassified
insertAsserts: aMethod using: anObserver
	anObserver memory 
		do: [ :observation | 
			| asserts |
			asserts := AbstractSerializer
				assertChanges: observation
				basedOn: anObserver memory.
			self insertAssertions: asserts in: aMethod on: observation ]