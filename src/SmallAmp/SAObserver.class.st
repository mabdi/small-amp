Class {
	#name : #SAObserver,
	#superclass : #Object,
	#instVars : [
		'targetClasses',
		'history',
		'chekingFlaky',
		'flankyIdx',
		'flakyMem'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'instance creation' }
SAObserver class >> newForTarget: targetClasses [
	^ self new newForTarget: targetClasses
]

{ #category : #adding }
SAObserver >> addOrCheck: obj [
	chekingFlaky
		ifFalse: [ history add: obj ]
		ifTrue: [ flakyMem add: obj ]
]

{ #category : #accessing }
SAObserver >> checkFlaky [
	history
		select: [ :item | item isValueObservation and: [ item observedBy = #observeResult ]  ]
		thenDo: [ :item | 
			flakyMem
				detect: [ :i | 
				i id = item id and: [ i observedBy = #observeResult ] ]
				ifFound: [ :i | self checkFlaky: item with: i ] ].
	history
		select: [ :item | item isValueObservation and: [item observedBy = #observe] ]
		thenDo: [ :item | 
			flakyMem
				detect: [ :i | i id = item id and: [ i observedBy = #observe ] ]
				ifFound: [ :i | self checkFlaky: item with: i ] ]
]

{ #category : #adding }
SAObserver >> checkFlaky: obj [
	| old |
	flankyIdx := flankyIdx + 1.
	old := history at: flankyIdx.
	self checkFlaky: old with: obj
]

{ #category : #testing }
SAObserver >> checkFlaky: oldOne with: newOne [
	(oldOne isKindOf: SAObservationValue) ifFalse: [ ^ self ].
	(newOne isKindOf: SAObservationValue) ifFalse: [ ^ self ].
	oldOne checkFlaky: newOne
]

{ #category : #accessing }
SAObserver >> flakyMem [
^flakyMem
]

{ #category : #'as yet unclassified' }
SAObserver >> getASerializer [
	^ SAStateSerializer new
]

{ #category : #accessing }
SAObserver >> history [
	^ history
]

{ #category : #initialization }
SAObserver >> initialize [
	history := OrderedCollection new.
	flakyMem := OrderedCollection new.
	chekingFlaky := false
]

{ #category : #testing }
SAObserver >> isInObservationScope: anObject [
	^ targetClasses
		anySatisfy: [ :c | 
			| c2 |
			c2 := anObject class.
			(c2 = c) | (c2 inheritsFrom: c) | (c2 = c class) ]
]

{ #category : #'instance creation' }
SAObserver >> newForTarget: listOfTargetClasses [
	self initialize.
	targetClasses := listOfTargetClasses
]

{ #category : #'as yet unclassified' }
SAObserver >> observe: anObject name: aString id: anInt [
	| serialized |
	(self isInObservationScope: anObject) ifFalse: [ ^ self ].
	serialized := anObject
		              smallAmpAcceptSerializerVisitor:
		              self getASerializer
		              atDepth: 0.
	serialized
		name: aString;
		id: anInt;
		observedBy: #observe.
	self addOrCheck: serialized
]

{ #category : #'as yet unclassified' }
SAObserver >> observeException: exception id: idx [
	| serialized |
	exception ifNil: [ ^ self ].
	serialized := SAObservationError forError:
		              exception class.
	serialized id: idx.
	self addOrCheck: serialized.
	
]

{ #category : #'as yet unclassified' }
SAObserver >> observeResult: aResult receiver: aReceiver selector: aSelector name: aString id: anInt [
	| serialized skipMe |
	skipMe := true.
	(self isInObservationScope: aReceiver)
		ifTrue: [ skipMe := false ].
	(self isInObservationScope: aResult)
		ifTrue: [ skipMe := false ].
	aReceiver == aResult
		ifTrue: [ skipMe := true ].	"the method is not an observer. it returns itself (Java alternative: void returning methods). "
	skipMe
		ifTrue: [ ^ false ].
	serialized := aResult
		smallAmpAcceptSerializerVisitor: self getASerializer
		atDepth: 0.
	serialized
		name: aString;
		id: anInt;
		observedBy: #observeResult.
	self addOrCheck: serialized
]

{ #category : #'as yet unclassified' }
SAObserver >> observeTimeOut: duarationInMilliSeconds id: idx [
	| serialized |
	serialized := SAObservationTimeout forTimeout:
		              duarationInMilliSeconds.
	serialized id: idx.
	self addOrCheck: serialized
]

{ #category : #'as yet unclassified' }
SAObserver >> resetFlakyDetection [
	chekingFlaky := true.
	flankyIdx := 0.
	flakyMem removeAll
]
