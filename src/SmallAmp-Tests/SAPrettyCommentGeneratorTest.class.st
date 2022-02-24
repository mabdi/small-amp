"
A SAPrettyCommentGeneratorTest is a test class for testing the behavior of SAPrettyCommentGenerator
"
Class {
	#name : #SAPrettyCommentGeneratorTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SAPrettyCommentGeneratorTest >> testEndToEnd [

[	| result cnf |
	cnf := SAConfig default.
	cnf maxPop: 10.
	cnf iterations: 1.
	cnf debugOn.
	result := (SmallAmp initializeWith: cnf)
		          testCase: FakeSmallBankTest;
		          amplifyAll.
	result inspect]
]

{ #category : #'as yet unclassified' }
SAPrettyCommentGeneratorTest >> testq [

	| generatedClass testMethods reducer readable uncovered cnf selection analysis |
	cnf := SAConfig default.
	testMethods := { 'testInit_amp_A4

	<smallAmpCoveres:
	''ReplaceIfTrueReceiverWithTrueOperator#FakeSmallBank#withdraw:#19#77''>
	<madeBySmallAmpFrom: ''FakeSmallBankTest>>#testInit''>
	| b |
	b := FakeSmallBank with: #empty.
	self assert: FakeSmallBank asString equals: ''FakeSmallBank''.
	self assert: b class equals: FakeSmallBank.
	self assert: b balance equals: 0.
	self assert: b rand class equals: SmallInteger.
	b withdraw: 30.
	self assert: b class equals: FakeSmallBank.
	self assert: b balance equals: 0.
	self assert: b rand class equals: SmallInteger'. 'testDeposit_amp

	<smallAmpCoveres: ''RemoveCaretOperator#FakeSmallBank#rand#28#50''>
	<madeBySmallAmpFrom: ''FakeSmallBankTest>>#testDeposit''>
	| b |
	b := FakeSmallBank new.
	self assert: FakeSmallBank asString equals: ''FakeSmallBank''.
	self assert: b class equals: FakeSmallBank.
	self assert: b balance equals: 0.
	self assert: b rand class equals: SmallInteger.
	b deposit: 10.
	self assert: b class equals: FakeSmallBank.
	self assert: b balance equals: 10.
	self assert: b rand class equals: SmallInteger.
	b deposit: 100.
	self assert: b class equals: FakeSmallBank.
	self assert: b balance equals: 110.
	self assert: b rand class equals: SmallInteger' }.
	generatedClass := SAGenericMethods new
		                  buildTestClassAndLogWith: testMethods
		                  using: FakeSmallBankTest.
	selection := SADSpotSelection initializeWith: cnf.
	analysis := selection
		            initialAnalysisFor: { FakeSmallBankTest }
		            targets: FakeSmallBankTest smallAmpTargetClasses
		            ignore: {  }.
	uncovered := selection uncovered collect: #mutant.
	reducer := (SAMuTalkFirstFailOracleReduction initializeWith: cnf)
		           with: generatedClass
		           from: FakeSmallBankTest
		           target: FakeSmallBankTest smallAmpTargetClasses
		           uncovered: uncovered.
	readable := reducer makeReducedResult.

	[ (readable >> readable testSelectors first) inspect ]. readable
		removeFromSystem.
	generatedClass removeFromSystem
]
