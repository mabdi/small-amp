asserting
makeAssertName: aName value: aValue last: theLast
	| assertStatements changes |
	changes := (aValue at: #value) keys
		select: [ :k | 
			theLast isNil
				or: [ ((SerializerFactory getUnserializer: ((aValue at: #value) at: k))
						isEqualWith: ((theLast at: #value) at: k)) not ] ].
	assertStatements := OrderedCollection new.
	changes
		do: [ :k | 
			assertStatements
				addAll:
					((SerializerFactory getUnserializer: ((aValue at: #value) at: k))
						class
						makeAssertName: k
						value: ((aValue at: #value) at: k)
						last: (theLast ifNotNil: [ (theLast at: #value) at: k ])) ].
	assertStatements
		do: [ :aRBMessageNode | 
			| tmp msgNode |
			tmp := aRBMessageNode arguments at: 1.
			msgNode := RBMessageNode receiver: (RBVariableNode named: aName) selector: tmp name.
			aRBMessageNode arguments at: 1 put: msgNode ].
	^ assertStatements