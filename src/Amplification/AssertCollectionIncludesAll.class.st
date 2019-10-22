Class {
	#name : #AssertCollectionIncludesAll,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
AssertCollectionIncludesAll >> assertPattern [
	^ '``@actual includesAll: ``@subcollection'
]

{ #category : #running }
AssertCollectionIncludesAll >> findPattern [
	^ {'self assertCollection: ``@actual includesAll: ``@subcollection'}
]
