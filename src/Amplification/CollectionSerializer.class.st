Class {
	#name : #CollectionSerializer,
	#superclass : #AbstractSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
CollectionSerializer class >> assertionsAddingName: aName value: aValue last: theLast [
	| a b d theObject assertStatement |
	theLast ifNil: [ ^ {} ].
	a := (aValue at: #value) copy.
	b := (theLast at: #value) copy.
	a size = (b size + 1)
		ifFalse: [ ^ {} ].
	b add: nil.
	d := OrderedCollection new.
	a
		doWithIndex: [ :obj :i | 
			(obj at: #type) = #primitive
				ifTrue: [ ((b at: i - d size) isNil
						or: [ ((SerializerFactory getUnserializer: obj)
								isEqualWith: (b at: i - d size)) not ])
						ifTrue: [ d ifNotEmpty: [ ^ {} ].
							d add: i ] ] ].
	d ifEmpty: [ ^ {} ].
	d := d at: 1.
	theObject := RBMessageNode
		receiver: (RBVariableNode named: aName)
		selector: #at:
		arguments: {(RBLiteralValueNode value: d)}.
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:description:
		arguments:
			{theObject.
			(RBLiteralValueNode
				value: (SerializerFactory unserialize: (a at: d)))
				.(RBLiteralValueNode value: 'smallAmp')}.
	^ {assertStatement}
]

{ #category : #'as yet unclassified' }
CollectionSerializer class >> assertionsRemovingName: aName value: aValue last: theLast [
	| a b d theObject assertStatement |
	theLast ifNil: [ ^ {} ].
	a := (aValue at: #value) copy.
	b := (theLast at: #value) copy.
	a size = (b size - 1)
		ifFalse: [ ^ {} ].
	a add: nil.
	d := OrderedCollection new.
	b
		doWithIndex: [ :obj :i | 
			(obj at: #type) = #primitive
				ifTrue: [ ((a at: i - d size) isNil
						or: [ ((SerializerFactory getUnserializer: obj)
								isEqualWith: (a at: i - d size)) not ])
						ifTrue: [ d ifNotEmpty: [ ^ {} ].
							d add: i ] ] ].
	d ifEmpty: [ ^ {} ].
	d := d at: 1.
	theObject := RBMessageNode
		receiver: (RBVariableNode named: aName)
		selector: #at:
		arguments: {(RBLiteralValueNode value: d)}.
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #deny:equals:description:
		arguments:
			{theObject.
			(RBLiteralValueNode
				value: (SerializerFactory unserialize: (b at: d))).(RBLiteralValueNode value: 'smallAmp')}.
	^ {assertStatement}
]

{ #category : #'as yet unclassified' }
CollectionSerializer class >> assertionsSizeName: aName value: aValue last: theLast [
	| assertStatement theObject theValue |
	(theLast isNil
		or: [ (aValue at: #value) size ~= (theLast at: #value) size ])
		ifFalse: [ ^ {} ].
	theObject := RBMessageNode
		receiver: (RBVariableNode named: aName)
		selector: #size.
	theValue := RBLiteralValueNode value: (aValue at: #value) size.
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:description:
		arguments:
			{theObject.
			theValue.(RBLiteralValueNode value: 'smallAmp')}.
	^ {assertStatement}
]

{ #category : #'as yet unclassified' }
CollectionSerializer class >> assertionsUpdatingName: aName value: aValue last: theLast [
	| d asserts |
	theLast ifNil: [ ^ {} ].
	(aValue at: #value) size = (theLast at: #value) size
		ifFalse: [ ^ {} ].
	d := OrderedCollection new.
	(aValue at: #value)
		doWithIndex: [ :obj :i | 
			(obj at: #type) = #primitive
				ifTrue: [ ((SerializerFactory getUnserializer: obj)
						isEqualWith: ((theLast at: #value) at: i))
						ifFalse: [ d add: i ] ] ].
	asserts := OrderedCollection new.
	(d takeFirst: 3)
		do: [ :v | 
			| assertStatement theObject |
			theObject := RBMessageNode
				receiver: (RBVariableNode named: aName)
				selector: #at:
				arguments: {(RBLiteralValueNode value: v)}.
			assertStatement := RBMessageNode
				receiver: (RBSelfNode named: 'self')
				selector: #assert:equals:description:
				arguments:
					{theObject.
					(RBLiteralValueNode
						value: (SerializerFactory unserialize: ((aValue at: #value) at: v))).
					(RBLiteralValueNode value: 'smallAmp')}.
			asserts add: assertStatement.
			theObject := RBMessageNode
				receiver: (RBVariableNode named: aName)
				selector: #at:
				arguments: {(RBLiteralValueNode value: v)}.
			assertStatement := RBMessageNode
				receiver: (RBSelfNode named: 'self')
				selector: #deny:equals:description:
				arguments:
					{theObject.
					(RBLiteralValueNode
						value: (SerializerFactory unserialize: ((theLast at: #value) at: v))).(RBLiteralValueNode value: 'smallAmp')}.
			asserts add: assertStatement ].
	^ asserts
]

{ #category : #asserting }
CollectionSerializer class >> makeAssertName: aName value: aValue last: theLast [
	| assertStatements |
	assertStatements := OrderedCollection new.
	assertStatements
		addAll: (self assertionsSizeName: aName value: aValue last: theLast).
	assertStatements
		addAll: (self assertionsAddingName: aName value: aValue last: theLast).
	assertStatements
		addAll: (self assertionsUpdatingName: aName value: aValue last: theLast).
	assertStatements	
		addAll: (self assertionsRemovingName: aName value: aValue last: theLast).
	^ assertStatements
]

{ #category : #'as yet unclassified' }
CollectionSerializer class >> myTag [
	^ #collection
]

{ #category : #accessing }
CollectionSerializer class >> priority [
	^ 20
]

{ #category : #'as yet unclassified' }
CollectionSerializer class >> supportingTypes [
	^ {Collection}
]

{ #category : #'as yet unclassified' }
CollectionSerializer class >> unserialize: dictionary [
	^ (dictionary at: #class)
		withAll:
			((dictionary at: #value)
				collect: [ :item | SerializerFactory unserialize: item ])
]

{ #category : #testing }
CollectionSerializer >> isEqualWith: theLast [
	(dictionary at: #value) size = (theLast at: #value) size
		ifFalse: [ ^ false ].
	(dictionary at: #value)
		with: (theLast at: #value)
		do: [ :item1 :item2 | 
			((SerializerFactory getUnserializer: item1) isEqualWith: item2)
				ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #private }
CollectionSerializer >> serializeDepth: anInt [
	| value result |
	value := anInt - 1 > 0
		ifTrue: [ | aCollection |
			aCollection := OrderedCollection new.
			object
				do:
					[ :item | aCollection add: (SerializerFactory serialize: item depth: anInt - 1) ].
			aCollection ]
		ifFalse: [ nil ].
	result := Dictionary
		newFrom:
			{(#value -> value).
			(#class -> object class).
			(#type -> self class myTag)}.
	^ result
]
