as yet unclassified
insertObservers: aMethod
	| i |
	i := 0.
	targetNodes
		do: [ :x | 
			| idx y rcv |
			idx := aMethod body statements indexOf: x.
			rcv := nil.
			x value class = RBCascadeNode
				ifTrue: [ rcv := (x value messages at: 1) receiver ].
			x value class = RBMessageNode
				ifTrue: [ rcv := x value receiver ].
			rcv
				ifNotNil: [ i := i + 1.
					y := RBMessageNode
						receiver: (RBSelfNode named: 'self')
						selector: #observe:name:id:
						arguments:
							{x variable.
							(RBLiteralValueNode value: x variable name).
							(RBLiteralValueNode value: i)}.
					i := i + 1.
					aMethod body statements add: y afterIndex: idx.
					((rcv isKindOf: RBVariableNode) and: [((rcv name first isUppercase not) and: [ x variable name ~=  rcv name ]) ])
						ifTrue: [ y := RBMessageNode
								receiver: (RBSelfNode named: 'self')
								selector: #observe:name:id:
								arguments:
									{rcv.
									(RBLiteralValueNode value: rcv name).
									(RBLiteralValueNode value: i)}.
							aMethod body statements add: y afterIndex: idx + 1 ] ] ]