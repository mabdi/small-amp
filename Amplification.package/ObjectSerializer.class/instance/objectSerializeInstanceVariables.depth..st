as yet unclassified
objectSerializeInstanceVariables: anObject depth: anInt
	| result |
	result := Dictionary new.
	anObject class instanceVariables
		do: [ :variable | 
			result
				at: variable
				put:
					((SerializerFactory getSerializer: (anObject instVarNamed: variable))
						serializeSpecialDepth: anInt
						type: #instanceVariable
						extra: nil) ].
	^ result