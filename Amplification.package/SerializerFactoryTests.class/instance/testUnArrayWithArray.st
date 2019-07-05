tests
testUnArrayWithArray
	| value temp data |
	data := {1.
			2.
			{3}.
			4.
			5.
			6}.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data