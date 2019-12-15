Class {
	#name : #SAObservationPrimitive,
	#superclass : #SAObservationObject,
	#category : #'SmallAmp-Model'
}

{ #category : #'instance creation' }
SAObservationPrimitive class >> newForFalse [
	^ self newForClass: False values: false
]

{ #category : #'instance creation' }
SAObservationPrimitive class >> newForNil [
	^ self newForClass: UndefinedObject values: nil
]

{ #category : #'instance creation' }
SAObservationPrimitive class >> newForNumber: aNumber [
	^ self newForClass: aNumber class values: aNumber
]

{ #category : #'instance creation' }
SAObservationPrimitive class >> newForString: aString [
	^ self newForClass: aString class values: aString
]

{ #category : #'instance creation' }
SAObservationPrimitive class >> newForTrue [
	^ self newForClass: True values: true
]

{ #category : #'as yet unclassified' }
SAObservationPrimitive >> buildAssertionValue [
	| theValueNode |
	self isFlaky ifTrue: [ ^ nil ].
	theValueNode := RBLiteralValueNode value: theValue.
	theValueNode formattedCode = '''<an unprintable nonliteral value>'''
		ifTrue: [ ^ self buildAssertionValueAsString ]
		ifFalse: [ ^ self buildAssertionValueNormal ]
]

{ #category : #'as yet unclassified' }
SAObservationPrimitive >> buildAssertionValueAsString [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: name.
	theObject := RBMessageNode receiver: theObject selector: #asString.
	theValueNode := RBLiteralValueNode value: theValue asString.
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
SAObservationPrimitive >> buildAssertionValueNormal [
	| assertStatement theObject theValueNode |
	
	theObject := RBVariableNode named: name.
	theValueNode := RBLiteralValueNode value: theValue.
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
SAObservationPrimitive >> buildAssertions [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: self buildAssertionType.
	asserts add: self buildAssertionValue.
	^ asserts
]

{ #category : #adding }
SAObservationPrimitive >> checkFlaky: anItem [
	anItem theClass = self theClass ifFalse: [ self isFlaky: true ].
	anItem theValue = self theValue ifFalse: [ self isFlaky: true ]

]

{ #category : #testing }
SAObservationPrimitive >> isPrimitive [
	^ true
]
