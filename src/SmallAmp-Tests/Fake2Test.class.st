Class {
	#name : #Fake2Test,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Fakes'
}

{ #category : #tests }
Fake2Test >> testNotSigned [
	self assert: true
]

{ #category : #tests }
Fake2Test >> testSigned [
	<madeBySmallAmp>
	self assert: true
]
