tests
testArray
	| value |
	value := AbstractSerializer serialize: {1 . 2 . 3 . 4 . 5 . 6}.
	self assert: (value at: #type) equals: #collection.
	self assert: (value at: #class) equals: Array.
	self assert: (value at: #value) size equals: 6.
	self assert: (((value at: #value) at: 3) at: #value) equals: '3'.
	self
		assert: (((value at: #value) at: 3) at: #class)
		equals: SmallInteger