"
A SAMethodProfilerTest is a test class for testing the behavior of SAMethodProfiler
"
Class {
	#name : #SAMethodProfilerTest,
	#superclass : #TestCase,
	#category : #'Amplification-Tests-Core'
}

{ #category : #tests }
SAMethodProfilerTest >> testMethodClassifier [
	SAMethodProfiler classifyClass: SmallBank.
	self
		assert: (SAMethodProfiler classes at: (SmallBank >> #balance) name)
		equals: (Set with: #testing).
	self
		assert: (SAMethodProfiler classes at: (SmallBank >> #deposit:) name)
		equals: (Set with: #updating).
	self
		assert:
		(SAMethodProfiler classes at: (SmallBank >> #withdraw:) name)
		equals: (Set with: #updating)
]
