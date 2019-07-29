private
serializeSpecialDepth: anInt type: aString extra: anObject
	| value |
	value := nil.
	anInt - 1 > 0
		ifTrue: [ aString = #accessing
				ifTrue: [ value:= self objectSerializeAccessing: object depth: anInt - 1 ].
			aString = #profile
				ifTrue: [ value:= self objectSerializeProfile: anObject depth: anInt - 1 ].
			aString = #instanceVariable
				ifTrue: [ value:= self objectSerializeInstanceVariables: object depth: anInt - 1 ] ].
	^ Dictionary
		newFrom:
			{(#value -> value).
			(#class -> object class).
			(#type -> self class myTag)}