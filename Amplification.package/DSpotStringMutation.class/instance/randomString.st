as yet unclassified
randomString
	^ (String new: 32)
		collect: [ :each | self characterSet atRandom ]