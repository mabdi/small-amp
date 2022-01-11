Class {
	#name : #FakeForTestCorrectionTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Fakes'
}

{ #category : #testing }
FakeForTestCorrectionTest >> expectedFailures [
	^ #(	testCorrectMe )
]

{ #category : #tests }
FakeForTestCorrectionTest >> testCorrectMe [

	| str |
	str := 'Hello world'.
	self assert: str size equals: 678.
	self assert: str first equals: $H.
	self assert: str second equals: $H
]
