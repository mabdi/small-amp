Class {
	#name : #DenyEquals,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
DenyEquals >> assertPattern [
	^ '(``@expected = ``@actual) not'
]

{ #category : #running }
DenyEquals >> findPattern [
	^ {'self deny: ``@actual equals: ``@expected'}
]
