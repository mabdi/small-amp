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

{ #category : #accessing }
SAAbstractProfiler >> initialize [
	profile:= Dictionary new
]

{ #category : #accessing }
SAAbstractProfiler >> profile [
	^ profile
]

{ #category : #'as yet unclassified' }
SAAbstractProfiler >> profileClasses: aTargetClass byRunning: aTestSuite [
	self subclassResponsibility
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
