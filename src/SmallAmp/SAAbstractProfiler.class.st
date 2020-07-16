Class {
	#name : #SAAbstractProfiler,
	#superclass : #Object,
	#instVars : [
		'config',
		'profile',
		'samples'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #initialization }
SAAbstractProfiler class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #'instance creation' }
SAAbstractProfiler >> config: aConfig [
	config := aConfig
]

{ #category : #accessing }
SAAbstractProfiler >> initialize [
	self reset
]

{ #category : #accessing }
SAAbstractProfiler >> profile [
	^ profile
]

{ #category : #'as yet unclassified' }
SAAbstractProfiler >> profileClasses: aTargetClass byRunning: aTestSuite [
	self profileClasses: aTargetClass byRunningTests: {aTestSuite}
]

{ #category : #'as yet unclassified' }
SAAbstractProfiler >> profileClasses: aTargetClass byRunningTests: aListOfTest [
	self subclassResponsibility
]

{ #category : #initialization }
SAAbstractProfiler >> reset [
	profile := Dictionary new.
	samples := Dictionary new
]

{ #category : #accessing }
SAAbstractProfiler >> samples [
	^ samples
]

{ #category : #'instance creation' }
SAAbstractProfiler >> with: aConfig [
	self initialize.
	config := aConfig
]
