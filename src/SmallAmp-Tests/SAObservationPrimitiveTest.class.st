"
A SAObservationPrimitiveTest is a test class for testing the behavior of SAObservationPrimitive
"
Class {
	#name : #SAObservationPrimitiveTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Model'
}

{ #category : #tests }
SAObservationPrimitiveTest >> testCheckFlaky [
	| item1 item2 p1 p2 |
	p1 := 10.
	p2 := 11.
	item1 := p1
		         smallAmpAcceptSerializerVisitor:
		         SAObjectObserversSerializer new
		         atDepth: 0.
	item2 := p2
		         smallAmpAcceptSerializerVisitor:
		         SAObjectObserversSerializer new
		         atDepth: 0.
	self deny: item1 isFlaky.
	item1 checkFlaky: item2.
	self assert: item1 isFlaky
]
