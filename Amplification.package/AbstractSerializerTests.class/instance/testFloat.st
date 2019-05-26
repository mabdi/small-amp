tests
testFloat
	| value |
	value := AbstractSerializer serialize: 1.54.
	self assert: (value at: #type) equals: #string.
	self assert: (value at: #class) equals: SmallFloat64.
	self assert: (value at: #value) equals: '1.54'