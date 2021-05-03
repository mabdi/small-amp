Extension { #name : #SmallAmp }

{ #category : #'*SmallAmp-Tests' }
SmallAmp class >> example [
	| result |
	result := SmallAmp initializeDefault
		testCase: SmallBankTest targets: {SmallBank};
		testCase: SmallBank2Test targets: {SmallBank2};
		amplifyAll.
	^ result
]
