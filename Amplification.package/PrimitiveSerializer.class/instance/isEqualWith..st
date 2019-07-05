testing
isEqualWith: theLast
	^ (self unserialize) = (SerializerFactory unserialize: theLast)