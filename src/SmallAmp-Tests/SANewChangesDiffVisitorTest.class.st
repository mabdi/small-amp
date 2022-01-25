"
A SANewChangesDiffVisitorTest is a test class for testing the behavior of SANewChangesDiffVisitor
"
Class {
	#name : #SANewChangesDiffVisitorTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SANewChangesDiffVisitorTest >> testOnSmallBank [

	| newDiff repo theClass toCommit visitor |
	theClass := SATestObject.
	theClass compile: 'aNewTest ^ 1'.
	toCommit := OrderedCollection with: theClass >> #aNewTest.
	visitor := SANewChangesDiffVisitor new methodsToCommit: toCommit.
	repo := IceRepository registry detect: [ :r | r name = 'small-amp' ].
	repo workingCopyDiff accept: visitor.
	self assert: visitor newTree size equals: 1.
	
	newDiff := repo workingCopyDiff copyWithOnly: visitor newTree.
	self assert: newDiff tree children first definition name equals: 'src'.
	self assert: newDiff tree children first children first definition name equals: 'SmallAmp-Tests'.
	self assert: newDiff tree children first children first children first definition name equals: theClass name.
	self assert: newDiff tree children first children first children first children first definition name equals: #aNewTest.
	
	theClass removeSelector: #aNewTest
]
