Class {
	#name : #PrimitiveSerializer,
	#superclass : #AbstractSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #asserting }
PrimitiveSerializer class >> makeAssertName: aName value: aValue last: theLast [
	| assertStatements theObject theValue variableValue |
	
	assertStatements := OrderedCollection new.
	aValue at: #flaky ifPresent: [^ assertStatements ].
	theObject := RBVariableNode named: aName.
	variableValue := SerializerFactory unserialize: aValue.
	theValue := RBLiteralValueNode value: variableValue.
	theValue formattedCode = '''<an unprintable nonliteral value>'''
		ifTrue: [ self halt ].
	assertStatements
		add:
			(RBMessageNode
				receiver: (RBSelfNode named: 'self')
				selector: #assert:equals:description:
				arguments:
					{theObject.
					theValue.
					(RBLiteralValueNode value: 'smallAmp')}).
	assertStatements
		addAllFirst: (self assertClassName: (aValue at: #class) name: aName).
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
