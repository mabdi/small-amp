"
A SADefaultSimplificationTest is a test class for testing the behavior of SADefaultSimplification
"
Class {
	#name : #SADefaultSimplificationTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #test }
SADefaultSimplificationTest >> testIsAssertion [
	| ins node |
	ins := SADefaultSimplification new.
	node := RBParser parseExpression: 'a:= 1'.
	self deny: (ins isAssertion: node).
	node := RBParser parseExpression: 'self assert: 1 equals: 1'.
	self assert: (ins isAssertion: node).
	node := RBParser parseExpression: 'self deny: false'.
	self assert: (ins isAssertion: node).
	node := RBParser parseExpression: 'a someMessage'.
	self deny: (ins isAssertion: node).
	node := RBParser parseExpression: 'a assert:1'.
	self deny: (ins isAssertion: node).
	node := RBParser parseExpression: 'self assert'.
	self deny: (ins isAssertion: node).
	node := RBParser parseExpression: 'some deny'.
	self deny: (ins isAssertion: node).
	node := RBParser parseExpression: 'self foo'.
	self deny: (ins isAssertion: node)
]
