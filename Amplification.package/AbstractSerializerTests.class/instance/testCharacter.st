tests
testCharacter
	| value |
	value := AbstractSerializer serialize: $t.
	self assert: (value at: #type) equals: #string.
	self assert: (value at: #class) equals: Character.
	self assert: (value at: #value) equals: 't'