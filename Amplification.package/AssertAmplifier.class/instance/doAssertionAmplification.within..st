as yet unclassified
doAssertionAmplification: aMethodSrc within: aClass
	| generatedClass observer aMethod |
	aMethod := RBParser parseMethod: aMethodSrc.
	self insertObservers: aMethod.
	generatedClass := self buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	self insertAsserts: aMethod using: observer.
	^ aMethod formattedCode