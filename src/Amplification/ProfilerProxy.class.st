Class {
	#name : #ProfilerProxy,
	#superclass : #AbstractProxy,
	#instVars : [
		'class',
		'profile'
	],
	#category : #'Amplification-Core'
}

{ #category : #'instance creation' }
ProfilerProxy class >> for: aClass [
	^ self class new initializeFor: aClass
]

{ #category : #initialization }
ProfilerProxy >> initializeFor: aClass [
	class := aClass.
	profile := Dictionary new
]

{ #category : #initialization }
ProfilerProxy >> observeAfter: aSelector with: anArray in: aReceiver return: aReturn [
	profile at: aSelector ifAbsentPut: OrderedCollection new.
	(profile at: aSelector)
		addAfterArgs: (self stateCapture:anArray)
		state: (self stateCapture: aReceiver)
		returns: (self stateCapture: aReturn)
]

{ #category : #initialization }
ProfilerProxy >> observeBefore: aSelector with: anArray in: aReceiver [
	profile at: aSelector ifAbsentPut: OrderedCollection new.
	(profile at: aSelector)
		addBeforeArgs: (self stateCapture:anArray)
		state: (self stateCapture: aReceiver)
]

{ #category : #'as yet unclassified' }
ProfilerProxy >> stateCapture: anObject [
]

{ #category : #'as yet unclassified' }
ProfilerProxy >> stateCapture: anObject depth: anInt [
	| result |
	anInt < 0
		ifTrue: [ ^ nil ].
	(anObject isKindOf: Collection)
		ifTrue: [ result := anObject
				collect: [ :item | self stateCapture: item depth: anInt - 1 ].
			^ result ].
	anObject isKindOf: Number
]
