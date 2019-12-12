Class {
	#name : #AssertCollectionIncludesAll,
	#superclass : #AssertTransform,
	#category : #'Amplification-Experiment'
}

{ #category : #running }
AssertCollectionIncludesAll >> assertPattern [
	^ '``@actual includesAll: ``@subcollection'
]

{ #category : #running }
AssertCollectionIncludesAll >> findPattern [
	^ {'self assertCollection: ``@actual includesAll: ``@subcollection'}
]
