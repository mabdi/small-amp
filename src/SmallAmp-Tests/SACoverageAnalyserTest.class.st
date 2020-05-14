"
A SACoverageAnalyserTest is a test class for testing the behavior of SACoverageAnalyser
"
Class {
	#name : #SACoverageAnalyserTest,
	#superclass : #TestCase,
	#instVars : [
		'ins'
	],
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #running }
SACoverageAnalyserTest >> setUp [
	
ins := SACoverageAnalyser new
	
]

{ #category : #tests }
SACoverageAnalyserTest >> testRun [
	ins classes: {SmallBank}; testCases: {SmallBankTest}; run.
	self
		assert: ins methodsCovered > 0;
		assert: ins branchesCovered > 0;
		assert: ins statementsCovered > 0
]
