tests
testCharacter
	| value |
	value := SerializerFactory serialize: $t.
	self assert: (value at: #type) equals: #primitive.
	self assert: (value at: #class) equals: Character.
	self assert: (value at: #value) equals: 't'