as yet unclassified
getSerializer: anObject
	self serializers
		detect: [ :s | s canSerialize: anObject ]
		ifFound: [ :s | ^ s serializer: anObject ]