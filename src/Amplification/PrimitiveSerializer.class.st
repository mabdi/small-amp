Class {
	#name : #PrimitiveSerializer,
	#superclass : #AbstractSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #asserting }
PrimitiveSerializer class >> makeAssertName: aName value: aValue last: theLast [
	| assertStatement theObject theValue |
	theObject := RBVariableNode named: aName.
	theValue := RBLiteralValueNode
		value: (SerializerFactory unserialize: aValue).
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:description:
		arguments:
			{theObject.
			theValue .     RBLiteralValueNode value: 'smallAmp'      }.
	^ {assertStatement}
]

{ #category : #'as yet unclassified' }
PrimitiveSerializer class >> myTag [
	^ #primitive
]

{ #category : #testing }
PrimitiveSerializer >> isEqualWith: theLast [
	^ (self unserialize) = (SerializerFactory unserialize: theLast)
]

{ #category : #private }
PrimitiveSerializer >> serializeDepth: anInt [
	^ Dictionary
		newFrom:
			{(#value -> object asString).
			(#class -> object class).
			(#type -> self class myTag)}
]
