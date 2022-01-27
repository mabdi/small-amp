"
A SAMainLoopDspotTest is a test class for testing the behavior of SAMainLoopDspot
"
Class {
	#name : #SAMainLoopDspotTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #test }
SAMainLoopDspotTest >> testScoreTestsWithUncovered [

	| instance uncovered randomGen |
	instance := SAMainLoopDspot new.
	uncovered := {  }.
	randomGen := Random seed: 10.
	instance scoreTestsWithUncovered: uncovered randomGen: randomGen.
	self assert: instance nextTest isNil
]

{ #category : #test }
SAMainLoopDspotTest >> testScoreTestsWithUncovered2 [

	| instance cnf randomGen |
	cnf := SAConfig default.
	instance := SAMainLoopDspot
		            with: cnf
		            for: FakeSmallBankTest
		            targets: { FakeSmallBank }.
	randomGen := Random seed: 10.
	instance theTS: instance initTs.
	instance setupSelection.
	instance
		scoreTestsWithUncovered: instance uncovered
		randomGen: randomGen.
	self assert: instance nextTest selectorOriginal equals: #testWithdraw
]
