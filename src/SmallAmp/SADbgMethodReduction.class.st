Class {
	#name : #SADbgMethodReduction,
	#superclass : #SAAbstractMethodReduction,
	#instVars : [
		'dbgList'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADbgMethodReduction >> dbgAdd: item [
	dbgList add: item
]

{ #category : #'as yet unclassified' }
SADbgMethodReduction >> dbgList [
	^ dbgList 
]

{ #category : #initialization }
SADbgMethodReduction >> initialize [ 
	dbgList := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SADbgMethodReduction >> reduceMethods: aListOfMethods [
	^ (aListOfMethods select: [ :m | self dbgList includes: m selector ]) ifEmpty: [ aListOfMethods ]
]
