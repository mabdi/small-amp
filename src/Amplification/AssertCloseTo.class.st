Class {
	#name : #AssertCloseTo,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
AssertCloseTo >> assertPattern [
	^ '``@actual closeTo: ``@expected'
]

{ #category : #running }
AssertCloseTo >> findPattern [
	^ {'self assert: ``@actual closeTo: ``@expected'}
]
