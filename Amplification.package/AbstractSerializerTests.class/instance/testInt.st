tests
testInt
	| value |
	value := AbstractSerializer serialize: 10.
	self assert: (value at: #type) equals: #string.
	self assert: (value at: #class) equals: SmallInteger.
	self assert: (value at: #value) equals: '10'