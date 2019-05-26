initialization
initializeWith: atestClass target: aTarget iterations: anInt popSize: anIntPopsize
	| obj |
	obj := self new.
	obj testClass: atestClass.
	obj targetClasses: aTarget.
	obj iterations: anInt.
	obj popSize: anIntPopsize.
	^ obj