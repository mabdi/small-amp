as yet unclassified
getUnserializer: aDic
	| unserializer |
	unserializer := aDic
		at: #unserializer
		ifAbsent: [ aDic
				at: #unserializer
				put:
					(self serializers
						detect: [ :s | s canUnSerialize: aDic ]
						ifFound: [ :s | ^ s unserializer: aDic ]
						ifNone: [self error: 'No unserializer' ]) ].
	^ unserializer