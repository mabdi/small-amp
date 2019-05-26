as yet unclassified
objectOldSerialize: anObject depth: anInt
	| result |
	result := Dictionary new.
	anObject class
		instanceVariableNamesDo: [ :l | 
			result
				at: l
				put: (super serialize: (anObject instVarNamed: l) depth: anInt) ].
	^ result