as yet unclassified
objectSerialize: anObject depth: anInt
	| result |
	result := Dictionary new.
	((anObject class methodsInProtocol: #accessing)
		select: [ :method | (method selector indexOf: $:) = 0 ])
		do: [ :l | 
			result
				at: l selector
				put: (super serialize: (anObject perform: l selector) depth: anInt) ].
	^ result