"
A SAMuTalkFirstFailOracleReductionTest is a test class for testing the behavior of SAMuTalkFirstFailOracleReduction
"
Class {
	#name : #SAMuTalkFirstFailOracleReductionTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #tests }
SAMuTalkFirstFailOracleReductionTest >> testMakeReducedResult [

	| ugly uncovered reducer readable |
	ugly := FakeUglyPureSmallBankTest.

	uncovered := { 'ReplacePlusWithMinusMutantOperator#FakeSmallBank#deposit:#29#44' } 
		             collect: [ :str | 
		             SADefaultTestCorrection createMutantFromString: str ].
	reducer := (SAMuTalkFirstFailOracleReduction initializeWith:
		            SAConfig default)
		           with: ugly
		           from: FakeUglySmallBankTest
		           target: { FakeSmallBank }
		           uncovered: uncovered.
	readable := reducer makeReducedResult.
	self
		assert:
			((readable >> #testAmplified_1) ast allStatements select: [ :node | 
				 node isMessage and: [ node selector = #assert:equals: ] ]) size
		equals: 1.

	readable removeFromSystem
]

{ #category : #tests }
SAMuTalkFirstFailOracleReductionTest >> testMakeReducedResultImpure [

	| ugly uncovered reducer readable |
	ugly := FakeUglyImpureSmallBankTest.

	uncovered := { 'ReplacePlusWithMinusMutantOperator#FakeSmallBank#deposit:#29#44' } 
		             collect: [ :str | 
		             SADefaultTestCorrection createMutantFromString: str ].
	reducer := (SAMuTalkFirstFailOracleReduction initializeWith:
		            SAConfig default)
		           with: ugly
		           from: FakeUglySmallBankTest
		           target: { FakeSmallBank }
		           uncovered: uncovered.
	readable := reducer makeReducedResult.
	
	self
		assert:
			((readable >> #testAmplified_1) ast allStatements select: [ :node | 
				 node isMessage and: [ node selector = #assert:equals: ] ]) size
		equals: 1.

	readable removeFromSystem
]

{ #category : #test }
SAMuTalkFirstFailOracleReductionTest >> testRemoveErrorBlocks [

	| listOfIds instance mtd mtd2 mtdSrc |
	mtdSrc := 'someMethod | a b c d e f | a := 1. [b:=2]on:Error do: [self smallamp_logs: 1. self assert: false]. d := [self do: 3]on:Error do: [self smallamp_logs: 2. self assert: false]'.
	mtd := RBParser parseMethod: mtdSrc.
	instance := SAMuTalkFirstFailOracleReduction new.
	listOfIds := { (#some -> 1) }.
	mtd2 := instance transformBackBaseOn: listOfIds in: mtd.
	instance removeErrorBlocks: mtd2.
	self
		assertMethodSourceCode: mtd2 formattedCode
		equals:
		'someMethod | a b c d e f | a := 1. b:=2 '.
	mtd := RBParser parseMethod: mtdSrc.
	instance := SAMuTalkFirstFailOracleReduction new.
	listOfIds := { (#some -> 2) }.
	mtd2 := instance transformBackBaseOn: listOfIds in: mtd.
	instance removeErrorBlocks: mtd2.
	self
		assertMethodSourceCode: mtd2 formattedCode
		equals: 'someMethod | a b c d e f | a := 1. . d := self do: 3'
]

{ #category : #test }
SAMuTalkFirstFailOracleReductionTest >> testStripMethod [
	| instance mtd mtd2 |
	mtd := RBParser
		parseMethod: 'foo  x:=0. self assert: true. x:=x+1.self foo'.
	instance := SAMuTalkFirstFailOracleReduction new.
	mtd2 := instance stripMethod: mtd.
	self
		assertMethodSourceCode: mtd2
		equals: 'foo  x:=0. self assert: true. x:=x+1.self foo'.
	mtd := RBParser
		parseMethod: 'foo  x:=0. self assert: true. x:=x+1.self foo. x:=x+x'.
	mtd2 := instance stripMethod: mtd.
	self
		assertMethodSourceCode: mtd2
		equals: 'foo  x:=0. self assert: true. x:=x+1.self foo'
]
