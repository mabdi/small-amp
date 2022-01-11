Class {
	#name : #SAAbstractTestCorrection,
	#superclass : #Object,
	#instVars : [
		'config',
		'theClass'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAbstractTestCorrection >> checkTest: selector stillCovers: coverage [
	self subclassResponsibility 
]

{ #category : #accessing }
SAAbstractTestCorrection >> config [

	^ config
]

{ #category : #accessing }
SAAbstractTestCorrection >> config: anObject [

	config := anObject
]

{ #category : #'as yet unclassified' }
SAAbstractTestCorrection >> fixTest: selector [
	self subclassResponsibility 
]

{ #category : #accessing }
SAAbstractTestCorrection >> theClass [

	^ theClass
]

{ #category : #accessing }
SAAbstractTestCorrection >> theClass: anObject [

	theClass := anObject
]
