Class {
	#name : #SADbgMethodReduction,
	#superclass : #SAAbstractMethodReduction,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADbgMethodReduction >> dbgList [
	^ {#testSearch_amp_L306}
]

{ #category : #'as yet unclassified' }
SADbgMethodReduction >> reduceMethods: aListOfMethods [
	^ aListOfMethods select: [ :m | self dbgList includes: m selector  ]
]
