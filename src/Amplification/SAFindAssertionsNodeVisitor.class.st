Class {
	#name : #SAFindAssertionsNodeVisitor,
	#superclass : #RBProgramNodeVisitor,
	#instVars : [
		'isInsideAnAsserion',
		'theSelector',
		'isOutSideAnAsserion'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
SAFindAssertionsNodeVisitor >> checkInsideAssertion: aMessageNode [
	| messageParents |
	
	messageParents := aMessageNode parent parents
		select: [ :aNode | aNode isKindOf: RBMessageNode ].
	messageParents ifEmpty: [ isOutSideAnAsserion := true ].
	messageParents
		do: [ :aParentMessageNode | 
			TestAsserter selectors
				detect: [ :aSelector | aParentMessageNode selector = aSelector ]
				ifFound: [ :aSelector | isInsideAnAsserion := true ]
				ifNone: [ isOutSideAnAsserion := true ] ]
]

{ #category : #accessing }
SAFindAssertionsNodeVisitor >> initializeForSelector: aSelector [
	theSelector := aSelector.
	isInsideAnAsserion := false.
	isOutSideAnAsserion := false.
]

{ #category : #accessing }
SAFindAssertionsNodeVisitor >> isInsideAnAsserion [
	^ isInsideAnAsserion
]

{ #category : #accessing }
SAFindAssertionsNodeVisitor >> isOutSideAnAsserion [
	^ isOutSideAnAsserion
]

{ #category : #accessing }
SAFindAssertionsNodeVisitor >> theSelector: aSelector [
	theSelector := aSelector 
]

{ #category : #visiting }
SAFindAssertionsNodeVisitor >> visitMessageNode: aMessageNode [
	aMessageNode selector = theSelector
		ifTrue: [ self checkInsideAssertion: aMessageNode  ].
	super visitMessageNode: aMessageNode
]
