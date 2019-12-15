Class {
	#name : #SAObservationObject,
	#superclass : #SAObservationValue,
	#category : #'Amplification-Model'
}

{ #category : #'as yet unclassified' }
SAObservationObject >> appendMyNameToAssert: aRBMessageNode [
	| tmp msgNode |
		tmp := aRBMessageNode arguments at: 1.
		msgNode := RBParser parseExpression: name , ' ' , tmp formattedCode.
		aRBMessageNode arguments at: 1 put: msgNode
]

{ #category : #'as yet unclassified' }
SAObservationObject >> buildAssertions [
	| asserts |
	asserts := OrderedCollection new.
	theValue keysDo: [ :key | 
		(theValue at: key) name: key.
		asserts addAll: (theValue at: key) buildAssertions ].
	asserts := asserts reject: #isNil.
	asserts do: [ :assertion | self appendMyNameToAssert: assertion ].
	^ asserts
]

{ #category : #adding }
SAObservationObject >> checkFlaky: anItem [
	self theValue keysDo: [ :key | 
		(self theValue at: key) checkFlaky: (anItem theValue at: key) 
		 ]
]
