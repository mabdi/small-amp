Class {
	#name : #SAReceiverTypeProfiler,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'testTargets',
		'config',
		'links',
		'directCalls'
	],
	#category : #'SmallAmp-Complementary'
}

{ #category : #'as yet unclassified' }
SAReceiverTypeProfiler class >> directCallsFor: aTestClass [
	| dict vals |
	aTestClass allTestSelectors ifEmpty: [ ^ '0' ].
	dict := (self initializeWith: SAConfig default)
		testClass: aTestClass;
		testTargets: aTestClass smallAmpTargetClasses;
		run.
	vals := dict directCalls values.
	vals
		ifEmpty: [ ^ '0' ]
		ifNotEmpty: [ ^ vals sum / aTestClass allTestSelectors size
				printShowingDecimalPlaces: 2 ]
]

{ #category : #initialization }
SAReceiverTypeProfiler class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #removing }
SAReceiverTypeProfiler >> astHelper [
	^ SAGenericMethods new
]

{ #category : #removing }
SAReceiverTypeProfiler >> buildMetalink [
	| l |
	l := MetaLink new
		metaObject: self;
		control: #before;
		selector: #executeSendReceiver:node:;
		arguments: #(receiver node);
		yourself.
	links add: l.
	^ l
]

{ #category : #accessing }
SAReceiverTypeProfiler >> directCalls [
	^ directCalls ifNil: [ directCalls := Dictionary new ]
]

{ #category : #removing }
SAReceiverTypeProfiler >> executeSendReceiver: receiver node: node [
	[ receiver class inheritsFrom: Object ]
		on: Error
		do: [ ^ self ].
	self directCalls at: node methodNode selector ifAbsentPut: [ 0 ].
	(self isInScope: receiver class)
		ifTrue: [ 
			self directCalls
				at: node methodNode selector
				put: (self directCalls at: node methodNode selector) + 1 ]
]

{ #category : #removing }
SAReceiverTypeProfiler >> initialize [ 
	links := OrderedCollection new
]

{ #category : #removing }
SAReceiverTypeProfiler >> installMetaLinksOnMethod: method [
	method ast allChildren
		select: #isMessage
		thenDo:
			[ :node | node link: self buildMetalink ]
]

{ #category : #testing }
SAReceiverTypeProfiler >> isInScope: aType [
	^ self testTargets
		anySatisfy: [ :c | aType = c | (aType inheritsFrom: c) | (aType = c class) ]
]

{ #category : #running }
SAReceiverTypeProfiler >> run [
	[ testClass allTestSelectors
		do: [ :selector | self installMetaLinksOnMethod: testClass >> selector ].
	[ testClass suite run ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ self error: 'receiver profiling timeout' ] ]
		ensure: [ links do: #uninstall ]
]

{ #category : #accessing }
SAReceiverTypeProfiler >> testClass [
	^ testClass
]

{ #category : #accessing }
SAReceiverTypeProfiler >> testClass: anObject [
	testClass := anObject
]

{ #category : #accessing }
SAReceiverTypeProfiler >> testTargets [
	^ testTargets
]

{ #category : #accessing }
SAReceiverTypeProfiler >> testTargets: anObject [
	testTargets := anObject
]

{ #category : #'instance creation' }
SAReceiverTypeProfiler >> with: aConfig [
	self initialize.
	config := aConfig
]
