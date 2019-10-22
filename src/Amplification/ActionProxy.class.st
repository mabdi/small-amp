Class {
	#name : #ActionProxy,
	#superclass : #MethodCallProxy,
	#instVars : [
		'action'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #initialization }
ActionProxy >> initializeFor: aMethod action: anAction [
	
	self initializeFor: aMethod.
	action := anAction
]

{ #category : #'changing suspended state' }
ActionProxy >> run: aSelector with: anArray in: aReceiver [
	| result |
	action observeBefore: aSelector with: anArray in: aReceiver.
	result := aReceiver withArgs: anArray executeMethod: method.
	action
		observeAfter: aSelector
		with: anArray
		in: aReceiver
		return: result.
	^ result
]
