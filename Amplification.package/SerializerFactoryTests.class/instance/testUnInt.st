tests
testUnInt
	
	| value temp data |
	data := 10.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data