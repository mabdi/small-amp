"
A SAObjectObserversSerializerTest is a test class for testing the behavior of SAObjectObserversSerializer
"
Class {
	#name : #SAObjectObserversSerializerTest,
	#superclass : #TestCase,
	#category : #'Amplification-Tests-Helpers'
}

{ #category : #test }
SAObjectObserversSerializerTest >> testFilterObserversOn [
	| obj res serializer |
	obj := SmallBank new.
	serializer := SAObjectObserversSerializer new.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 2.
	obj := SAObservationPrimitive new.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 6.
	obj := #key -> 0.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 5
]
