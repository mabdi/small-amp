as yet unclassified
unserialize: aDic
	^ self serializers
		detect: [ :s | s canUnSerialize: aDic ]
		ifFound: [ :s | ^ s unserialize: aDic ]