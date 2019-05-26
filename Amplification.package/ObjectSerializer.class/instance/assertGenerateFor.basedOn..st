asserting
assertGenerateFor: anObservation basedOn: theLast
	| assertStatements changes |
	changes := (anObservation at: #value) keys
		select: [ :k | 
			theLast isNil
				or: [ (((anObservation at: #value) at: k) at: #type) = #primitive
						and: [ (self unserialize: ((anObservation at: #value) at: k))
								~= (self unserialize: ((theLast at: #value) at: k)) ] ] ].
					
	assertStatements := changes
		collect: [ :aChange | 
			| theObject theValue |
			theObject := RBMessageNode
				receiver: (RBVariableNode named: (anObservation at: #name))
				selector: aChange.
			theValue := RBLiteralValueNode
				value:
					(AbstractSerializer
						unserialize: ((anObservation at: #value) at: aChange)).
			RBMessageNode
				receiver: (RBSelfNode named: 'self')
				selector: #assert:equals:
				arguments:
					{theObject.
					theValue} ].
	^ assertStatements