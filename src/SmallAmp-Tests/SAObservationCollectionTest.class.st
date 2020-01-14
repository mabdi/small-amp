"
A SAObservationCollectionTest is a test class for testing the behavior of SAObservationCollection
"
Class {
	#name : #SAObservationCollectionTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Model'
}

{ #category : #test }
SAObservationCollectionTest >> testCheckFlaky [
	| item1 item2 arr1 arr2 |
	arr1 := Array with: 10 with: 20 with: 30.
	arr2 := Array with: 11 with: 20 with: 30.
	item1 := arr1
		         smallAmpAcceptSerializerVisitor:
		         SAStateSerializer new
		         atDepth: 0.
	item2 := arr2
		         smallAmpAcceptSerializerVisitor:
		         SAStateSerializer new
		         atDepth: 0.
	self deny: (item1 theValue at: 1) isFlaky.
	self deny: (item1 theValue at: 2) isFlaky.
	self deny: (item1 theValue at: 3) isFlaky.
	item1 checkFlaky: item2.
	self assert: (item1 theValue at: 1) isFlaky.
	self deny: (item1 theValue at: 2) isFlaky.
	self deny: (item1 theValue at: 3) isFlaky
]

{ #category : #test }
SAObservationCollectionTest >> testCheckFlakyDeep [
	| item1 item2 obj1 obj2 |
	obj1 := {1.
	2.
	3.
	{1.
	2.
	3.
	{1.
	2.
	3.
	{1.
	2.
	3.
	{1.
	2.
	3.
	{1.
	2.
	3.
	{1.
	2.
	3.
	{}}}}}}}}.
	obj2 := {1.
	2.
	3.
	{1.
	2.
	3.
	{1.
	2.
	3.
	{5.
	2.
	3.
	{1.
	2.
	3.
	{1.
	2.
	3.
	{1.
	2.
	3.
	{}}}}}}}}.
	item1 := obj1
		smallAmpAcceptSerializerVisitor: SAStateSerializer new
		atDepth: 0.
	item2 := obj2
		smallAmpAcceptSerializerVisitor: SAStateSerializer new
		atDepth: 0.
	item1 checkFlaky: item2.
	
]
