Class {
	#name : #SACoverageCountingHelper,
	#superclass : #Object,
	#instVars : [
		'testMethod',
		'testClass',
		'generatedClass',
		'links',
		'covereds'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> cleanUp [
	SAGenericMethods new
		removeClass: generatedClass
		source: self class name
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> executeBeforeSendReceiver: receiver selector: selector [

	covereds add: (receiver class >> selector) name
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> findAllCoveredMethods [

	"generate a temp class
	Install proxies (by metalink?) to all methods under test in the scope.
	Run the test.
	On each proxy trigger: log the receiver and selector
	"
	self generatTheTempClass.
	self halt
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> findImmediateCoveredMethods [

	"generate a temp class
	add metalink to all message sends inside the method.
	Run the test.
	On each metalink trigger: log the receiver and selector
	"

	[ 
	self generatTheTempClass.
	generatedClass testSelectors do: [ :selector | 
		self installMessageSendingMetalinksOn:
			(generatedClass lookupSelector: selector) ].
	SAGenericMethods new
		runSafelyTestClass: generatedClass
		timeOut: 5000 milliSeconds ] ensure: [ self cleanUp ].
	^ covereds 
]

{ #category : #running }
SACoverageCountingHelper >> generatTheTempClass [

	generatedClass := SAGenericMethods new
		                  buildTestClassWith: { testMethod }
		                  using: testClass.

]

{ #category : #initialization }
SACoverageCountingHelper >> initialize [

	links := OrderedCollection new.
	covereds := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SACoverageCountingHelper >> installMessageSendingMetalinksOn: aTestMethod [

	links := (aTestMethod ast allChildren select: #isMessage) collect: [ 
		         :msg | 
		         MetaLink new
			         metaObject: self;
			         control: #before;
			         selector: #executeBeforeSendReceiver:selector:;
			         arguments: #( receiver selector );
			         yourself ]
]

{ #category : #accessing }
SACoverageCountingHelper >> testClass: anObject [

	testClass := anObject
]

{ #category : #accessing }
SACoverageCountingHelper >> testMethod: anObject [

	testMethod := anObject
]
