as yet unclassified
doAssertAmplification: population amplifier: anAmplifier
	"1. Find targets, 2. Install observations, 3. Build method with population 4. run suite 5. read observation"

	targets := anAmplifier targetClasses.
	^ population
		collect: [ :tcase | self assertionAmplify: tcase ]
		displayingProgress: 'Assert amplifying'