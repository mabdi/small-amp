"
A SAMutationCoverageDSpotSelectionTest is a test class for testing the behavior of SAMutationCoverageDSpotSelection
"
Class {
	#name : #SAMutationCoverageDSpotSelectionTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #tests }
SAMutationCoverageDSpotSelectionTest >> test1 [
	| selection test |
	selection := SAMutationCoverageDSpotSelection
		initializeWith: SAConfig default.
	selection
		initialAnalysisFor: {SmallBankTest}
		targets: {SmallBank}
		ignore: {}.
	test := SATestMethod from: SmallBankTest >> #testWithdraw.
	self assert: selection uncovered size equals: 3.
	self assertEmpty: (selection select: {} forMutantAtIndex: 1).
	self assertEmpty: (selection select: {test} forMutantAtIndex: 1).
	test := test clone
		testMethod:
			'testWithdraw
	| b |
	b := SmallBank new.
	b deposit: 100.
	self assert: b balance equals: 100.
	b withdraw: 100.
	self assert: b balance equals: 0'.
	self assert: (selection select: {test} forMutantAtIndex: 1) size equals: 1.
	
]
