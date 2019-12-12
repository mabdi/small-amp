Class {
	#name : #AssertCollectionEqulas,
	#superclass : #AssertTransform,
	#category : #'Amplification-Experiment'
}

{ #category : #running }
AssertCollectionEqulas >> assertPattern [
	^ '``@actual = ``@expected'
]

{ #category : #running }
AssertCollectionEqulas >> findPattern [
	^ {'self assertCollection: ``@actual equals: ``@expected'}
]
