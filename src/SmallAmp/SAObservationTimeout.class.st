Class {
	#name : #SAObservationTimeout,
	#superclass : #SAObservationAbstract,
	#instVars : [
		'timeout'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationTimeout class >> forTimeout: aMilliSec [
	^ self new with: aMilliSec; yourself
]

{ #category : #'as yet unclassified' }
SAObservationTimeout >> buildAssertionForTimeout [
	| assertStatement theMessage theTimeOut theDiscription |
	theMessage := RBVariableNode named: 'fake'.
	theTimeOut := RBMessageNode
		              receiver: (RBVariableNode named: 'Duration')
		              selector: #milliSeconds:
		              arguments: { (RBLiteralValueNode value: timeout) }.
	theDiscription := RBLiteralValueNode value: 'smallAmp'.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #should:takeMoreThan:description:
		                   arguments: { 
				                   theMessage.
				                   theTimeOut.
				                   theDiscription }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAObservationTimeout >> buildAssertions [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: self buildAssertionForTimeout.
	^ asserts
]

{ #category : #accessing }
SAObservationTimeout >> timeout [
^ timeout
]

{ #category : #accessing }
SAObservationTimeout >> with: aMilliSec [ 
	self initialize.
	timeout := aMilliSec 
]
