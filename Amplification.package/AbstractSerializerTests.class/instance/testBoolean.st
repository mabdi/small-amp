tests
testBoolean
	| value |
	value := AbstractSerializer serialize: true.
	self assert: (value at: #type) equals: #string.
	self assert: (value at: #class) equals: True.
	self assert: (value at: #value) equals: 'true'