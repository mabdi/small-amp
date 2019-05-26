private
serialize: anObject depth: anInt
	| value |
	value := anInt - 1 > 0
		ifTrue: [ self objectSerialize: anObject depth: anInt - 1 ]
		ifFalse: [ nil ].
	^ Dictionary
		newFrom:
			{(#value -> value).
			(#class -> anObject class).
			(#type -> self myTag )}