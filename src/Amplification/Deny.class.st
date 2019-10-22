Class {
	#name : #Deny,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
Deny >> assertPattern [
	^ '``@aBooleanOrBlock value not'
]

{ #category : #running }
Deny >> findPattern [
	^ {'self deny: ``@aBooleanOrBlock' . 'self deny: ``@aBooleanOrBlock description: ``@aStringOrBlock'.
	'self deny: ``@aBooleanOrBlock description: ``@aStringOrBlock resumable: ``@resumableBoolean'.
	'self shouldnt: ``@aBooleanOrBlock' . 'self shouldnt: ``@aBooleanOrBlock description: ``@aStringOrBlock'}
]
