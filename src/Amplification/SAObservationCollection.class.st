Class {
	#name : #SAObservationCollection,
	#superclass : #SAObservationObject,
	#category : #'Amplification-Model'
}

{ #category : #'as yet unclassified' }
SAObservationCollection >> buildAssertionSize [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: name.
	theObject := RBMessageNode receiver: theObject selector: #size.
	theValueNode := RBLiteralValueNode value: (theValue size).
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:description:
		                   arguments: { 
				                   theObject.
				                   theValueNode.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #accessing }
SAObservationCollection >> buildAssertionValues [
	| assertStatement theObject theValueNode array |
	(theValue allSatisfy: [ :item | item isPrimitive ]) ifFalse: [ ^ nil ].
	theValue size > self maxCollectionSize ifTrue: [ ^ nil ].
	array := (theValue collect: [ :item | item theValue ]) asArray
		         .
	theObject := RBVariableNode named: name.
	theValueNode := RBLiteralArrayNode value: array.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:description:
		                   arguments: { 
				                   theObject.
				                   theValueNode.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAObservationCollection >> buildAssertions [
	| assertStatements |
	assertStatements := OrderedCollection new.
	assertStatements add: self buildAssertionType.
	assertStatements add: self buildAssertionSize.
	assertStatements add: self buildAssertionValues.
	assertStatements add: super buildAssertions. 
	^ assertStatements
]

{ #category : #adding }
SAObservationCollection >> checkFlaky: anItem [
	self theValue doWithIndex: [ :item :index | 
		(self theValue at: index) checkFlaky: (anItem theValue at: index) ]
]

{ #category : #accessing }
SAObservationCollection >> maxCollectionSize [
	^ 10
]
