"
A SAMuTalkFirstFailOracleReductionTest is a test class for testing the behavior of SAMuTalkFirstFailOracleReduction
"
Class {
	#name : #SAMuTalkFirstFailOracleReductionTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

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
