"
A SATonelMethodLocationFinderTest is a test class for testing the behavior of SATonelMethodLocationFinder
"
Class {
	#name : #SATonelMethodLocationFinderTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SATonelMethodLocationFinderTest >> testFakeTest [

	| t finder location strFromTonel src |
	t := FakeSmallBankTest >> #testDeposit.
	finder := SATonelMethodLocationFinder new
		          root: 'src';
		          yourself.
	location := finder locationFor: t.
	strFromTonel := finder tonelStringFor: t methodClass.
	src := t sourceCode.
	self
		assert: location filename
		equals: 'src/SmallAmp-Tests/FakeSmallBankTest.class.st'.
	self assert: (strFromTonel lines copyFrom: location startline + 1 to: location endline - 1) equals: src lines allButFirst
	"self assert: location startline equals: 8.
	self assert: location endline equals: 15"
]
