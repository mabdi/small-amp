tests
testUnFloat
	
	| value temp data |
	data := 1.54.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data