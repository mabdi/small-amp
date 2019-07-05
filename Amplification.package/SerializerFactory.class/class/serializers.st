accessing
serializers
	^ serializers
		ifNil: [ serializers := (AbstractSerializer allSubclasses
				select: [ :s | s priority > 0 ])
				sorted: [ :s1 :s2 | s1 priority < s2 priority ] ]