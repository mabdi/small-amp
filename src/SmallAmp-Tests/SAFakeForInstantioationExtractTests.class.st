Class {
	#name : #SAFakeForInstantioationExtractTests,
	#superclass : #TestCase,
	#instVars : [
		'cnf',
		'a',
		'w'
	],
	#category : #'SmallAmp-Tests-Fakes'
}

{ #category : #running }
SAFakeForInstantioationExtractTests >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	cnf := SAConfig default.
	a := 4
]

{ #category : #tests }
SAFakeForInstantioationExtractTests >> testN1 [
	| sa x y z t q |
	x := 1 / 2.
	y := 10.
	z := 9 / y.
	w := 3 / a.
	t := y.
	q :=  w.
	sa := SmallAmp initializeWith: cnf
]
