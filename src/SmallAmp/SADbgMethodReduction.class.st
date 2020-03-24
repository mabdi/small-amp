Class {
	#name : #SADbgMethodReduction,
	#superclass : #SAAbstractMethodReduction,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADbgMethodReduction >> dbgList [
	^ {#testRoomExitCycles_amp}
]

{ #category : #'as yet unclassified' }
SADbgMethodReduction >> reduceMethods: aListOfMethods [
	^ (aListOfMethods select: [ :m | self dbgList includes: m selector ]) ifEmpty: [ aListOfMethods ]
]
