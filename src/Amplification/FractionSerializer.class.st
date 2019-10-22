Class {
	#name : #FractionSerializer,
	#superclass : #NumberSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #asserting }
FractionSerializer class >> makeAssertName: aName value: aValue last: theLast [
	| assertStatements theObject theValue variableValue |
	assertStatements := OrderedCollection new.
	theObject := RBVariableNode named: aName.
	theObject := RBMessageNode receiver: theObject selector: #asString.
	variableValue := SerializerFactory unserialize: aValue.
	theValue := RBLiteralValueNode value: variableValue asString.
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
FractionSerializer class >> priority [
	
	^ 9
]

{ #category : #'as yet unclassified' }
FractionSerializer class >> supportingTypes [
	^ {Fraction}
]

{ #category : #'as yet unclassified' }
FractionSerializer class >> unserialize: dictionary [
	| val |
	val := (dictionary at: #value) copyWithoutAll: '()'.
	^ Fraction readFrom: val
]
