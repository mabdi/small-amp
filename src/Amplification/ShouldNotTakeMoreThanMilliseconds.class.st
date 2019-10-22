Class {
	#name : #ShouldNotTakeMoreThanMilliseconds,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
ShouldNotTakeMoreThanMilliseconds >> assertPattern [
	^ '[``@aBlock value. true] valueWithin: (Duration milliSeconds: ``@anInteger)
		onTimeout: [false]'
]

{ #category : #running }
ShouldNotTakeMoreThanMilliseconds >> findPattern [
	^ {'self should: ``@aBlock notTakeMoreThanMilliseconds: ``@anInteger'}
]
