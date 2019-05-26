private
serialize: anObject depth: anInt
	self serializers
		detect: [ :s | s canSerialize: anObject ]
		ifFound: [ :s | ^ s serialize: anObject depth: anInt ]