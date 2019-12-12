Class {
	#name : #AssertIdenticalTo,
	#superclass : #AssertTransform,
	#category : #'Amplification-Experiment'
}

{ #category : #running }
AssertIdenticalTo >> assertPattern [
	^ '``@expected == ``@actual'
]

{ #category : #running }
AssertIdenticalTo >> findPattern [
	^ {'self assert: ``@actual identicalTo: ``@expected'}
]
