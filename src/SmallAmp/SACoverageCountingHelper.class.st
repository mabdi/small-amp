Class {
	#name : #SACoverageCountingHelper,
	#superclass : #Object,
	#instVars : [
		'aTestMethod',
		'aTestClass',
		'generatedClass',
		'covereds',
		'aSelector',
		'coverageOn',
		'links'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> checkInCoverageScope: receiver selector: selector [

	| method |
	method := receiver class lookupSelector: selector.
	method class = SAProfilingProxy ifTrue: [ method := method method ].
	(coverageOn includes: method ) ifTrue: [ 
		covereds add: method ]
]

{ #category : #accessing }
SACoverageCountingHelper >> coverageOn: anObject [

	coverageOn := anObject
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> executeBeforeSendReceiver: receiver selector: selector [

	self checkInCoverageScope: receiver selector: selector
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> findAllCoveredMethods [

	^ self generateAndRunProfiler: [ self installProxies ] cleaner: [ 
		  self uninstallProxies.
		  self removeTempClass ].
	
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> findImmediateCoveredMethods [

	^ self
		  generateAndRunProfiler: [ self installMessageSendingMetalinks ]
		  cleaner: [ self removeTempClass  ]
]

{ #category : #running }
SACoverageCountingHelper >> generatTheTempClass [

	generatedClass := SAGenericMethods new
		                  buildTestClassWith: { aTestMethod }
		                  using: aTestClass
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> generateAndRunProfiler: aBlock cleaner: aBlock2 [

	[ 
	self generatTheTempClass.
	aBlock value.
	SAGenericMethods new
		runSafelyTestClass: generatedClass
		selector: aSelector
		timeOut: 5000 milliSeconds ] ensure: aBlock2 .
	^ covereds
]

{ #category : #initialization }
SACoverageCountingHelper >> initialize [

	covereds := OrderedCollection new.
	links := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> installMessageSendingMetalinks [

	| link theTestMethod |
	theTestMethod := generatedClass lookupSelector: aSelector .
	link := MetaLink new
		        metaObject: self;
		        control: #before;
		        selector: #executeBeforeSendReceiver:selector:;
		        arguments: #( receiver selector );
		        yourself.
	(theTestMethod ast allChildren select: #isMessage) do: [ :msg | 
		msg link: link ]
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> installProxies [

	coverageOn  
		 do: [ :mtd | self installProxyOn: mtd ] 
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> installProxyOn: aMethod [

	| link |
	link := SAProfilingProxy on: aMethod profiler: self.
	link install.
	links add: link
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> preCall: theSelector with: anArray in: aReceiver [

	self checkInCoverageScope: aReceiver selector: theSelector
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> removeTempClass [

	SAGenericMethods new
		removeClass: generatedClass
		source: self class name
]

{ #category : #accessing }
SACoverageCountingHelper >> selector: anObject [

	aSelector := anObject
]

{ #category : #accessing }
SACoverageCountingHelper >> testClass: anObject [

	aTestClass := anObject
]

{ #category : #accessing }
SACoverageCountingHelper >> testMethod: anObject [

	aTestMethod := anObject
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> uninstallProxies [

	links do: [ :link | link uninstall] 
]
