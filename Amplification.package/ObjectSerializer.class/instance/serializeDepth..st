private
serializeDepth: anInt
	| value |
	value := anInt - 1 > 0
		ifTrue: [ self objectSerialize: object depth: anInt - 1 ]
		ifFalse: [ nil ].
	^ Dictionary
		newFrom:
			{(#value -> value).
			(#class -> object class).
			(#type -> self class myTag)}