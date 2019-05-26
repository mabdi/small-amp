tests
testString
	| value |
	value := AbstractSerializer serialize: 'Hello World'.
	self assert: (value at: #type) equals: #string.
	self assert: (value at: #class) equals: ByteString.
	self assert: (value at: #value) equals: 'Hello World'