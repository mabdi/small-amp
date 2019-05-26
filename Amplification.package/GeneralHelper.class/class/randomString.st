as yet unclassified
randomString
	^ (String new: 8) collect: [ :each | (Character alphabet,'0123456789',Character alphabet asUppercase) atRandom ]