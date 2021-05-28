Extension { #name : #TestCase }

{ #category : #'*SmallAmp-Complementary' }
TestCase class >> smallAmpAssertionDensity [
	| methods |
	methods := self methods select: #isTestMethod.
	^ ((methods
		collect: [ :m | SATestAssertionDensity new densityForMethod: m ])
		inject: 0
		into: [ :s :i | s + i ]) / methods size printShowingDecimalPlaces: 2
]
