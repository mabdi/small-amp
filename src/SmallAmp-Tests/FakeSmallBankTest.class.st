Class {
	#name : #FakeSmallBankTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Fakes'
}

{ #category : #tests }
FakeSmallBankTest >> testDeposit [
	| b |
	b := FakeSmallBank new.
	b deposit: 10.
	self assert: b balance equals: 10.
	b deposit: 100.
	self assert: b balance equals: 110
]

{ #category : #tests }
FakeSmallBankTest >> testInit [

	| b |
	b := FakeSmallBank with: #empty.
	self assert: b balance equals: 0
]

{ #category : #test }
FakeSmallBankTest >> testLoadFrom [
	| b1 b2 |
	b1 := FakeSmallBank new.
	b1 deposit: 40.
	b2 := FakeSmallBank new.
	b2 loadFrom: b1.
	self assert: b2 balance equals: 40
]

{ #category : #tests }
FakeSmallBankTest >> testWithdraw [
	| b |
	b := FakeSmallBank new.
	b deposit: 100.
	self assert: b balance equals: 100.
	b withdraw: 30.
	self assert: b balance equals: 70
]
