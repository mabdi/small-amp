private
serializeDepth: anInt
	| value result |
	value := anInt - 1 > 0
		ifTrue: [ | aCollection |
			aCollection := OrderedCollection new.
			object
				do: [ :item | aCollection add: (SerializerFactory  serialize: item depth: anInt - 1) ].
			aCollection ]
		ifFalse: [ nil ].
	result := Dictionary
		newFrom:
			{(#value -> value).
			(#class -> object class).
			(#type -> self class myTag)}.
	^ result