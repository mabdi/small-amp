Class {
	#name : #ShouldNotTakeMoreThan,
	#superclass : #AssertTransform,
	#category : #'Amplification-Experiment'
}

{ #category : #running }
ShouldNotTakeMoreThan >> assertPattern [
	^ '[``@aBlock value. true] valueWithin: ``@aDuration
		onTimeout: [  false]'
]

{ #category : #running }
ShouldNotTakeMoreThan >> findPattern [
	^ {'self should: ``@aBlock notTakeMoreThan: ``@aDuration'}
]
