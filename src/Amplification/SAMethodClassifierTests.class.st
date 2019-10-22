Class {
	#name : #SAMethodClassifierTests,
	#superclass : #TestCase,
	#instVars : [
		'instance'
	],
	#category : #'Amplification-Tests'
}

{ #category : #running }
SAMethodClassifierTests >> setUp [
	
]

{ #category : #tests }
SAMethodClassifierTests >> testMethodClassifier [

	SAMethodClassifier classifyClass: SmallBank.
	self
		assert: (SAMethodClassifier classes at: (SmallBank >> #balance) name)
		equals: (Set with: #testing).
	self
		assert: (SAMethodClassifier classes at: (SmallBank >> #deposit:) name)
		equals: (Set with: #updating).
	self
		assert: (SAMethodClassifier classes at: (SmallBank >> #withdraw:) name)
		equals: (Set with: #updating)
]
