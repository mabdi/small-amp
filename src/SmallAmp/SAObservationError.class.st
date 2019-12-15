Class {
	#name : #SAObservationError,
	#superclass : #SAObservationAbstract,
	#instVars : [
		'theError'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationError class >> forError: exception [
	^ self new
		with: exception;
		yourself
]

{ #category : #'as yet unclassified' }
SAObservationError >> buildAssertionForError [
	| assertStatement theMessage theErrorNode theDiscription |
	theMessage := RBVariableNode named: 'fake'.
	theErrorNode := RBVariableNode named: theError name.
	theDiscription := RBLiteralValueNode value: 'smallAmp'.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #should:raise:description:
		                   arguments: { 
				                   theMessage.
				                   theErrorNode.
				                   theDiscription }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAObservationError >> buildAssertions [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: self buildAssertionForError.
	^ asserts
]

{ #category : #'instance creation' }
SAObservationError >> theError [
	^ theError
]

{ #category : #'instance creation' }
SAObservationError >> with: anException [
	self initialize.
	theError := anException
]
