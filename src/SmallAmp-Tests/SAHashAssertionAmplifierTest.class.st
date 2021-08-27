Class {
	#name : #SAHashAssertionAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'aConfig',
		'ins'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #tests }
SAHashAssertionAmplifierTest >> testCase1 [
	| item config amplifier selection res mutants |
	config := SAConfig default.
	amplifier := SADiffAssertionAmplifier initializeWith: config.
	amplifier testRunTimeoutMillis: 1000.
	mutants := RemoveCaretOperator new
		mutationsFor: FakeSmallBank >> #rand.
	selection := SAMutationTestingDiffSelection initializeWith: config.
	item := self
		testModelFor: (FakeSmallBankTest >> #testInit) sourceCode.
	selection
		uncovered:
			(mutants
				collect: [ :aMutant | 
					MutantEvaluationResultSurvived
						newFor: aMutant
						results: nil
						producedBy: nil ]).
	item strip.
	item assertionAmplifyBy: amplifier.
	self
		assertMethodSourceCode: item testMethod
		equals:
			'testInit
	| b |
	b := FakeSmallBank with: #empty.
	self
		assertObjectState: FakeSmallBank
		varName: ''FakeSmallBank''
		id: 1
		type: #observe.
	self
		assertObjectState: b
		varName: #b
		id: 1
		type: #observeResult'.
	
	res := selection select: {item}.
	self
		assertMethodSourceCode: res first testMethod
		equals:
			'testInit
	<smallAmpCoveres: ''RemoveCaretOperator#FakeSmallBank#rand#28#50''>
	| b |
	b := FakeSmallBank with: #empty.
	self assert: b class equals: FakeSmallBank.
	self assert: b rand class equals: SmallInteger'
]

{ #category : #tests }
SAHashAssertionAmplifierTest >> testModelFor: src [
	^ SATestMethod
		with: src
		class: TestCase
		targets: {FakeSmallBank}
]
