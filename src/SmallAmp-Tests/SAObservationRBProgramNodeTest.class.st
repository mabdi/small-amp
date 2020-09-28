"
A SAObservationRBProgramNodeTest is a test class for testing the behavior of SAObservationRBProgramNode
"
Class {
	#name : #SAObservationRBProgramNodeTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Model'
}

{ #category : #test }
SAObservationRBProgramNodeTest >> testCheckFlaky [
	| item1 item2 p1 p2 |
	p1 := RBParser parseExpression: '10'.
	p2 := RBParser parseExpression: '11'.
	item1 := p1
		smallAmpAcceptSerializerVisitor: SAStateSerializer new
		atDepth: 0.
	item2 := p2
		smallAmpAcceptSerializerVisitor: SAStateSerializer new
		atDepth: 0.
	self deny: item1 isFlaky.
	item1 checkFlaky: item2.
	self assert: item1 isFlaky
]

{ #category : #test }
SAObservationRBProgramNodeTest >> testCheckFlakyMethod [
	| item1 item2 p1 p2 |
	p1 := RBParser parseMethod: 'foo 1+1. ^ 2'.
	p2 := RBParser parseMethod: 'foo 1+1. ^ 1'.
	item1 := p1
		smallAmpAcceptSerializerVisitor: SAStateSerializer new
		atDepth: 0.
	item2 := p2
		smallAmpAcceptSerializerVisitor: SAStateSerializer new
		atDepth: 0.
	self deny: item1 isFlaky.
	item1 checkFlaky: item2.
	self assert: item1 isFlaky
]
