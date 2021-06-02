"
A SAMutationCoverageDSpotSelectionTest is a test class for testing the behavior of SAMutationCoverageDSpotSelection
"
Class {
	#name : #SAMutationCoverageDSpotSelectionTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #testing }
SAMutationCoverageDSpotSelectionTest >> expectedFailures [ 
	^ #(test1)
]

{ #category : #tests }
SAMutationCoverageDSpotSelectionTest >> test1 [
	| selection test |
	selection := SADSpotSelection
		initializeWith: SAConfig default.
	selection
		initialAnalysisFor: {SmallBankTest}
		targets: {SmallBank}
		ignore: {}.
	selection setUpShadowSelections.
	test := SATestMethod from: SmallBankTest >> #testWithdraw.
	self assert: selection uncovered size equals: 3.
	selection select: {} forMutantAtIndex: 1.
	self assertEmpty: selection finalizeShadowSelections.
	selection setUpShadowSelections.
	selection select: {test} forMutantAtIndex: 1.
	self assertEmpty: selection finalizeShadowSelections.
	test := test clone
		testMethod:
			'testWithdraw
	| b |
	b := SmallBank new.
	b deposit: 100.
	self assert: b balance equals: 100.
	b withdraw: 100.
	self assert: b balance equals: 0'.
	selection setUpShadowSelections.
	(selection select: {test} forMutantAtIndex: 1).
	self
		assert: (selection finalizeShadowSelections) size
		equals: 1.
]
