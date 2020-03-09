Class {
	#name : #SADefaultSimplification,
	#superclass : #SAAbstractSimplification,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADefaultSimplification >> simplify: aClass [
	self flag: #todo	"redundant statement reduction".
	self flag: #todo	"semantic reduction"
]
