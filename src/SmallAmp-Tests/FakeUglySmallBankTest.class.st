Class {
	#name : #FakeUglySmallBankTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Fakes'
}

{ #category : #tests }
FakeUglySmallBankTest >> testMethod1 [

	| b |
	b := FakeSmallBank new.
	b deposit: 10.
	self assert: b balance equals: 10.
	self assert: b balance + 1 equals: 11.
	self assert: b balance + 2 equals: 12.
	self assert: true.
	self assert: 5 + 5 equals: 10.
	self assert: 2 + 8 equals: 10.
	self assert: 0 + 10 equals: 10.
	b deposit: 100.

	self assert: b balance equals: 110.
	self assert: b balance + 1 equals: 111.
	self assert: b balance + 2 equals: 112.
	self assert: true.
	self assert: 50 + 50 equals: 100.
	self assert: 20 + 80 equals: 100.
	self assert: 0 + 100 equals: 100
]

{ #category : #tests }
FakeUglySmallBankTest >> testMethod2impure [

	| b |
	b := FakeSmallBank new.
	b deposit: 10.
	self assert: b balance equals: 10.
	self assert: (b deposit: 1) balance equals: 11.
	self assert: b balance + 1 equals: 12.
	self assert: true.
	self assert: 5 + 5 equals: 10.
	self assert: 2 + 8 equals: 10.
	self assert: 0 + 10 equals: 10.
	b deposit: 100.

	self assert: b balance equals: 111.
	self assert: b balance + 1 equals: 112.
	self assert: b balance + 2 equals: 113.
	self assert: true.
	self assert: 50 + 50 equals: 100.
	self assert: 20 + 80 equals: 100.
	self assert: 0 + 100 equals: 100
]
