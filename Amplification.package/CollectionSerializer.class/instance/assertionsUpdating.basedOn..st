as yet unclassified
assertionsUpdating: anObservation basedOn: theLast
	| a b d asserts |
	a := anObservation at: #unpack.
	b := {}.
	theLast ifNotNil: [ b := theLast at: #unpack ].
	a size = b size
		ifFalse: [ ^ {} ].
	asserts := OrderedCollection new.
	d := OrderedCollection new.
	(1 to: a size)
		do: [ :i | 
			(a at: i) = (b at: i)
				ifFalse: [ d add: i ] ].
	(d takeFirst: 3)
		do: [ :v | 
			| assertStatement theObject |
			((a at: v) isKindOf: Dictionary)
				ifFalse:[theObject := RBMessageNode
				receiver: (RBVariableNode named: (anObservation at: #name))
				selector: #at:
				arguments: {(RBLiteralValueNode value: v)}.
			assertStatement := RBMessageNode
				receiver: (RBSelfNode named: 'self')
				selector: #assert:equals:
				arguments:
					{theObject.
					(RBLiteralValueNode value: (a at: v))}.
			asserts add: assertStatement.
			theObject := RBMessageNode
				receiver: (RBVariableNode named: (anObservation at: #name))
				selector: #at:
				arguments: {(RBLiteralValueNode value: v)}.
			assertStatement := RBMessageNode
				receiver: (RBSelfNode named: 'self')
				selector: #deny:equals:
				arguments:
					{theObject.
					(RBLiteralValueNode value: (b at: v))}.
			asserts add: assertStatement] ].
	^ asserts