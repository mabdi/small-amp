as yet unclassified
doAssertAmplification: population amplifier: anAmplifier
	^ population
		collect: [ :tcase | self assertionAmplify: tcase ]
		displayingProgress: 'Assert amplifying'