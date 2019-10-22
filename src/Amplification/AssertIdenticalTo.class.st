Class {
	#name : #AssertIdenticalTo,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
AssertIdenticalTo >> assertPattern [
	^ '``@expected == ``@actual'
]

{ #category : #running }
AssertIdenticalTo >> findPattern [
	^ {'self assert: ``@actual identicalTo: ``@expected'}
]
