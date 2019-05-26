as yet unclassified
buildAnTestClassWith: aCollection using: testClass
	| tempClass |
	tempClass := testClass superclass
		subclass: (testClass name asString , self getId asString) asSymbol
		instanceVariableNames: testClass instanceVariablesString
		classVariableNames: ''
		category: 'Amplification-TempClasses'.
	#(#setUp #tearDown)
		do: [ :each | 
			testClass methods
				detect: [ :mtd | mtd selector = each ]
				ifFound: [ :item | tempClass compile: item sourceCode ] ].
	aCollection
		do: [ :item | 
			tempClass compile: item ].
	^ tempClass