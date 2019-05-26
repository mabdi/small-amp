private
serialize: anObject depth: anInt
	^ Dictionary
		newFrom:
			{(#value -> anObject asString).
			(#class -> anObject class).
			(#type -> self myTag)}