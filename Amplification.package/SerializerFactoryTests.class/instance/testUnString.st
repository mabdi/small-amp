tests
testUnString
	| value temp data |
	data := 'Hello World'.
	temp := SerializerFactory  serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data