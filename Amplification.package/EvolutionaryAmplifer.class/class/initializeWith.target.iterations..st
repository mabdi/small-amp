initialization
initializeWith: atestClass target: aTarget iterations: anInt
	| obj |
	obj := self new.
	obj testClass: atestClass.
	obj targetClasses: aTarget.
	obj iterations: anInt.
	^ obj