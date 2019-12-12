Class {
	#name : #SAMethodClassifierTests,
	#superclass : #TestCase,
	#instVars : [
		'instance'
	],
	#category : #AmplificationTests
}

{ #category : #running }
SAMethodClassifierTests >> setUp [
	
]

{ #category : #tests }
SAMethodClassifierTests >> testMethodClassifier [

	SAMethodProfiler classifyClass: SmallBank.
	self
		assert: (SAMethodProfiler classes at: (SmallBank >> #balance) name)
		equals: (Set with: #testing).
	self
		assert: (SAMethodProfiler classes at: (SmallBank >> #deposit:) name)
		equals: (Set with: #updating).
	self
		assert: (SAMethodProfiler classes at: (SmallBank >> #withdraw:) name)
		equals: (Set with: #updating)
]
