tests
testString
	| value |
	value := SerializerFactory serialize: 'Hello World'.
	self assert: (value at: #type) equals: #primitive.
	self assert: (value at: #class) equals: ByteString.
	self assert: (value at: #value) equals: 'Hello World'