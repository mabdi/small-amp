"
A SAMaxPopMethodReductionTest is a test class for testing the behavior of SAMaxPopMethodReduction
"
Class {
	#name : #SAMaxPopMethodReductionTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #test }
SAMaxPopMethodReductionTest >> testSetThePopSizeLimit [
	| x ins y x2 y2 |
	x := (1 to: 100) asOrderedCollection.
	ins := SAMaxPopMethodReduction new.
	y := ins setThePopSize: x limit: 30.
	self assert: y size equals: 30.
	self assert: ins pool size equals: 70.
	self assertEmpty: (y asSet intersection: ins pool asSet).
	x2 := (101 to: 110) asOrderedCollection.
	y2 := ins addPopFromPoolTo: x2 limit: 30.
	self assert: y2 size equals: 30.
	self assert: ins pool size equals: 50.
	self assertEmpty: (y2 asSet intersection: ins pool asSet).
	
]
