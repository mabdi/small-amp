Class {
	#name : #DenyIdenticalTo,
	#superclass : #AssertTransform,
	#category : #'Amplification-Experiment'
}

{ #category : #running }
DenyIdenticalTo >> assertPattern [
	^ '(``@expected == ``@actual) not'
]

{ #category : #running }
DenyIdenticalTo >> findPattern [
	^ {'self deny: ``@actual identicalTo: ``@expected'}
]
