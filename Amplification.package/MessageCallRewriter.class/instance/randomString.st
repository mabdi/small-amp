as yet unclassified
randomString
	| string |
	string := String
		streamContents: [ :stream | 
			stream write: Character alphabet.
			stream write: Character alphabet asUppercase.
			stream write: '0123456789' ].
	^ (String new: 10) collect: [ :each | string atRandom ]