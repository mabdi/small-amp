Class {
	#name : #AssertCloseTo,
	#superclass : #AssertTransform,
	#category : #'Amplification-Experiment'
}

{ #category : #running }
AssertCloseTo >> assertPattern [
	^ '``@actual closeTo: ``@expected'
]

{ #category : #running }
AssertCloseTo >> findPattern [
	^ {'self assert: ``@actual closeTo: ``@expected'}
]
