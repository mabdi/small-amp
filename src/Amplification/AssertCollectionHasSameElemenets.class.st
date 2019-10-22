Class {
	#name : #AssertCollectionHasSameElemenets,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
AssertCollectionHasSameElemenets >> assertPattern [
	^ '(``@actual difference: ``@expected) isEmpty and: [(``@expected
		difference: (``@actual intersection: ``@expected)) isEmpty]'
]

{ #category : #running }
AssertCollectionHasSameElemenets >> findPattern [
	^ {'self assertCollection: ``@actual hasSameElements: ``@expected'}
]
