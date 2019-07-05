tests
testUnCharacter
	
	| value temp data |
	data := $t.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data