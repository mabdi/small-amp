accessing
serializers
	^ serializers
		ifNil: [ serializers := (AbstractSerializer subclasses
				collect: [ :s | s instance ])
				sorted: [ :s1 :s2 | s1 priority < s2 priority ] ]