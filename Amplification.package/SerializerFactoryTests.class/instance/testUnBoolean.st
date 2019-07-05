tests
testUnBoolean
	
	| value temp data |
	data := true.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data