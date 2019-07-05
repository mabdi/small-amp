tests
testBoolean
	| value |
	value := SerializerFactory serialize: true.
	self assert: (value at: #type) equals: #primitive.
	self assert: (value at: #class) equals: True.
	self assert: (value at: #value) equals: 'true'