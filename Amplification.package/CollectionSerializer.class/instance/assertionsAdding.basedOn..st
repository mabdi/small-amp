as yet unclassified
assertionsAdding: anObservation basedOn: theLast
	| a b d asserts |
	a := anObservation at: #unpack.
	b := {}.
	theLast ifNotNil: [ b := theLast at: #unpack ].
	a size = (b size + 1)
		ifFalse: [ ^ {} ].
	asserts := OrderedCollection new.
	d := OrderedCollection new.
	(1 to: a size)
		do: [ :i | 
			(i - d size <= b size and: [ (a at: i) = (b at: i - d size) ])
				ifFalse: [ d add: i ] ].
	d
		do: [ :v | 
			| assertStatement theObject |
			((a at: v) isKindOf: Dictionary)
				ifFalse: [ theObject := RBMessageNode
						receiver: (RBVariableNode named: (anObservation at: #name))
						selector: #at:
						arguments: {(RBLiteralValueNode value: v)}.
					assertStatement := RBMessageNode
						receiver: (RBSelfNode named: 'self')
						selector: #assert:equals:
						arguments:
							{theObject.
							(RBLiteralValueNode value: (a at: v))}.
					asserts add: assertStatement ] ].
	^ asserts