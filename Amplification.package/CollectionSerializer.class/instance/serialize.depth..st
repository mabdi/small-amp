private
serialize: anObject depth: anInt
	| value result |
	value := anInt - 1 > 0
		ifTrue: [ | aCollection |
			aCollection := OrderedCollection new.
			anObject
				do: [ :item | aCollection add: (super serialize: item depth: anInt - 1) ].
			aCollection ]
		ifFalse: [ nil ].
	result := Dictionary
		newFrom:
			{(#value -> value).
			(#class -> anObject class).
			(#type -> self myTag)}.
	self class subclasses
		detect: [ :s | 
			s instance supportingTypes
				contains: [ :q | 
					q = anObject class
						or: [ q allSubclasses contains: [ :w | w = anObject class ] ] ] ]
		ifFound:
			[ :s | result at: #extra put: (s instance serialize: anObject depth: anInt) ].
	^ result