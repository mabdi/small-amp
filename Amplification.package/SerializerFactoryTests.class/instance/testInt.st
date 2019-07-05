tests
testInt
	| value |
	value := SerializerFactory serialize: 10.
	self assert: (value at: #type) equals: #primitive.
	self assert: (value at: #class) equals: SmallInteger.
	self assert: (value at: #value) equals: '10'