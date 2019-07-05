private
serializeDepth: anInt
	^ Dictionary
		newFrom:
			{(#value -> object asString).
			(#class -> object class).
			(#type -> self class myTag)}