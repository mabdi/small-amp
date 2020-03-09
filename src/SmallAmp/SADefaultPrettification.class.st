Class {
	#name : #SADefaultPrettification,
	#superclass : #SAAbstractPrettification,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADefaultPrettification >> prettify: aClass [
	self flag: #TODO.	"pack statements"
	self flag: #TODO.	"rename variables"
	
]
