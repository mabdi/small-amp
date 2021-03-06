"
A SAObservationObjectTest is a test class for testing the behavior of SAObservationObject
"
Class {
	#name : #SAObservationObjectTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Model'
}

{ #category : #tests }
SAObservationObjectTest >> testCheckFlaky [
	| item1 item2 obj1 obj2 |
	obj1 := SmallBank new.
	obj2 := SmallBank new.
	item1 := obj1
		         smallAmpAcceptSerializerVisitor:
		         SAStateSerializer new
		         atDepth: 0.
	item2 := obj1
		         smallAmpAcceptSerializerVisitor:
		         SAStateSerializer new
		         atDepth: 0.
	self deny: (item1 theValue at: #rand) isFlaky.
	self deny: (item1 theValue at: #balance) isFlaky.
	item1 checkFlaky: item2.
	self assert: (item1 theValue at: #rand) isFlaky.
	self deny: (item1 theValue at: #balance) isFlaky.
	
]

{ #category : #tests }
SAObservationObjectTest >> testPrivateField [
	| item1  obj1 |
	obj1 := SATestObject new.
	item1 := obj1
		smallAmpAcceptSerializerVisitor: SAStateSerializer new
		atDepth: 0.
	self deny: (item1 theValue includesKey: #rand)
]
