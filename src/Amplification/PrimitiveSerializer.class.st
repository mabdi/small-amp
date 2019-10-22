Class {
	#name : #PrimitiveSerializer,
	#superclass : #AbstractSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #asserting }
PrimitiveSerializer class >> makeAssertName: aName value: aValue last: theLast [
	| assertStatements theObject theValue |
	assertStatements := OrderedCollection new. 
	theObject := RBVariableNode named: aName.
	theValue := RBLiteralValueNode
		value: (SerializerFactory unserialize: aValue).
	assertStatements add: (RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:description:
		arguments:
			{theObject.
			theValue .     RBLiteralValueNode value: 'smallAmp'      }).
	assertStatements addFirst: (self assertClassName: (aValue at: #class) name name: aName).
	^ assertStatements
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
