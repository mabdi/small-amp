Class {
	#name : #FakeUglyImpureSmallBankTest,
	#superclass : #FakeUglySmallBankTest,
	#category : #'SmallAmp-Tests-Fakes'
}

{ #category : #tests }
FakeUglyImpureSmallBankTest >> testMethod2impure [

	<smallAmpCoveres:
	'ReplacePlusWithMinusMutantOperator#FakeSmallBank#deposit:#29#44'>
	<madeBySmallAmpFrom: 'FakeSmallBankTest>>#testDeposit'>
	| b |
	b := FakeSmallBank new.
	b deposit: 15.
	self assert: true.
	self assert: (b withdraw: 4) class equals: FakeSmallBank.
	self assert: b balance equals: 11.
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
