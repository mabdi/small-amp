Class {
	#name : #Assert,
	#superclass : #AssertTransform,
	#category : #'Amplification-Experiment'
}

{ #category : #running }
Assert >> assertPattern [
	^ '``@aBooleanOrBlock value'
]

{ #category : #running }
Assert >> findPattern [
	^ {'self assert: ``@aBooleanOrBlock' . 'self assert: ``@aBooleanOrBlock description: ``@aStringOrBlock'.
	'self assert: ``@aBooleanOrBlock description: ``@aStringOrBlock resumable: ``@resumableBoolean'.'self should: ``@aBooleanOrBlock' . 'self should: ``@aBooleanOrBlock description: ``@aStringOrBlock'}
]
