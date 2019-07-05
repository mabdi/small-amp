as yet unclassified
assertionsUpdatingName: aName value: aValue last: theLast
	| d asserts |
	theLast ifNil: [ ^ {} ].
	(aValue at: #value) size = (theLast at: #value) size
		ifFalse: [ ^ {} ].
	d := OrderedCollection new.
	(aValue at: #value)
		doWithIndex: [ :obj :i | 
			(obj at: #type) = #primitive
				ifTrue:
			[((SerializerFactory getUnserializer: obj)
				isEqualWith: ((theLast at: #value) at: i))
				ifFalse: [ d add: i ]] ].
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
				selector: #assert:equals:
				arguments:
					{theObject.
					(RBLiteralValueNode
						value: (SerializerFactory unserialize: ((aValue at: #value) at: v)))}.
			asserts add: assertStatement.
			theObject := RBMessageNode
				receiver: (RBVariableNode named: aName)
				selector: #at:
				arguments: {(RBLiteralValueNode value: v)}.
			assertStatement := RBMessageNode
				receiver: (RBSelfNode named: 'self')
				selector: #deny:equals:
				arguments:
					{theObject.
					(RBLiteralValueNode
						value: (SerializerFactory unserialize: ((theLast at: #value) at: v)))}.
			asserts add: assertStatement ].
	^ asserts