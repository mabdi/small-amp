Class {
	#name : #SAAbstractMethodLocationFinder,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SAAbstractMethodLocationFinder >> locationFor: aCompiledMethod [

	self subclassResponsibility 
]
