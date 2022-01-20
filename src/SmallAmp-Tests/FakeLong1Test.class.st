Class {
	#name : #FakeLong1Test,
	#superclass : #FakeSmallBankTest,
	#category : #'SmallAmp-Tests-Fakes'
}

{ #category : #'as yet unclassified' }
FakeLong1Test >> helper1 [
]

{ #category : #'as yet unclassified' }
FakeLong1Test >> helper2 [

	
]

{ #category : #tests }
FakeLong1Test >> testDeposit [

	| b |
	b := FakeSmallBank new.
	b deposit: 10.
	self assert: b balance equals: 10.
	b deposit: 100.
	self assert: b balance equals: 110
]

{ #category : #tests }
FakeLong1Test >> testEmpty1 [

	self assert: true.

]

{ #category : #tests }
FakeLong1Test >> testEmpty10 [

	self assert: true
]

{ #category : #tests }
FakeLong1Test >> testEmpty11 [

	self assert: true
]

{ #category : #tests }
FakeLong1Test >> testEmpty2 [

	self assert: true
]

{ #category : #tests }
FakeLong1Test >> testEmpty3 [

	self assert: true
]

{ #category : #tests }
FakeLong1Test >> testEmpty4 [

	self assert: true
]

{ #category : #tests }
FakeLong1Test >> testEmpty5 [

	self assert: true
]

{ #category : #tests }
FakeLong1Test >> testEmpty6 [

	self assert: true
]

{ #category : #tests }
FakeLong1Test >> testEmpty7 [

	self assert: true
]

{ #category : #tests }
FakeLong1Test >> testEmpty8 [

	self assert: true
]

{ #category : #tests }
FakeLong1Test >> testEmpty9 [

	self assert: true
]
