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
	#category : #'Amplification-Helpers'
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
		select: [ :item | (item at: #observedby) = #observeResult ]
		thenDo: [ :item | 
			flakyMem
				detect: [ :i | 
					(i at: #id) = (item at: #id) and: [ 
						(i at: #observedby) = #observeResult ] ]
				ifFound: [ :i | self checkFlaky: item with: i path: {  } ] ].
	history
		select: [ :item | (item at: #observedby) = #observe ]
		thenDo: [ :item | 
			flakyMem
				detect: [ :i | 
					(i at: #id) = (item at: #id) and: [ 
						(i at: #observedby) = #observe ] ]
				ifFound: [ :i | self checkFlaky: item with: i path: {  } ] ]
]

{ #category : #adding }
SAObserver >> checkFlaky: obj [
	| old |
	flankyIdx := flankyIdx + 1.
	old := history at: flankyIdx.
	self checkFlaky: old with: obj path: {  }
]

{ #category : #testing }
SAObserver >> checkFlaky: oldOne with: newOne path: apath [
	| oldVal newVal |
	
	oldVal := oldOne.
	newVal := newOne.
	apath
		do: [ :key | 
			oldVal := oldVal at: key.
			newVal := newVal at: key ].
	(oldVal at: #type ifAbsent: [ #ignore ]) = #object
		ifTrue: [ (oldVal at: #value) ifNotNil:[
				(oldVal at: #value) keysDo: [ :key | 
					| newPath |
					newPath := apath
						,
							{#value.
							key}.
					self checkFlaky: oldOne with: newOne path: newPath ] ]].
	(oldVal at: #type ifAbsent: [ #ignore ]) = #primitive
		ifTrue: [ ((oldVal at: #class) = (newVal at: #class)
				and: [ (oldVal at: #value) = (newVal at: #value) ])
				ifFalse: [ oldVal at: #flaky put: true ] ]
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
	^ targetClasses includes: anObject class 
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
		              SAObjectObserversSerializer new
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
	| serialized |
	aReceiver == aResult ifTrue: [ ^ self ]. "the method is not an observer. it returns itself (Java alternative: void returning methods). "
	serialized := aResult
		              smallAmpAcceptSerializerVisitor:
		              SAObjectObserversSerializer new
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
	flankyIdx := 0
]
