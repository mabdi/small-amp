Class {
	#name : #DenyCollectionEquals,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
DenyCollectionEquals >> assertPattern [
	^ '(``@expected = ``@actual) not'
]

{ #category : #running }
DenyCollectionEquals >> findPattern [
	^ {'self denyCollection: ``@actual equals: ``@expected'}
]
