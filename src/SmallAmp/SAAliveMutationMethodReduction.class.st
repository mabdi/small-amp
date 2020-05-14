Class {
	#name : #SAAliveMutationMethodReduction,
	#superclass : #SAAbstractMethodReduction,
	#instVars : [
		'testClass',
		'selectedMethods',
		'covered',
		'links'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #accessing }
SAAliveMutationMethodReduction >> astHelper [
	^ SAASTHelper new
]

{ #category : #cleanup }
SAAliveMutationMethodReduction >> cleanUp: aListOfMethods [
	config debug
		ifTrue: [ ^ self ].
	aListOfMethods do: [ :mtd | testClass removeSelector: mtd selector ]
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> executeBeforeNode [
	covered := true
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> genMetaLink [
	| l |
	l := MetaLink new
		metaObject: self;
		control: #before;
		selector: #executeBeforeNode;
		arguments: #();
		yourself.
		links add: l.
		^ l
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> initialize [
	
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> installMetaLinkTo: nodeToMutate [
	nodeToMutate
		do: [ :node | 
			node ast
				link: self genMetaLink
					 ]
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> makeTestClassWith: aListOfMethods [
	testClass
		ifNil: [ testClass := self astHelper
				buildTestClassWith: (aListOfMethods collect: #testMethod)
				using: aListOfMethods first testClass ]
		ifNotNil: [ (aListOfMethods collect: #testMethod) do: [ :src | testClass compile: src ]  ]
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> reduceMethods: aListOfMethods [
	| nodesToMutate |
	aListOfMethods ifEmpty: [ ^ aListOfMethods ].
	nodesToMutate := (uncovered collect: [ :u | u mutant originalMethod ])
		removeDuplicates.
	links := OrderedCollection new.
	self installMetaLinkTo: nodesToMutate.
	selectedMethods := OrderedCollection new.
	aListOfMethods
		do: [ :m | 
			self makeTestClassWith: {m}.
			self runTestClassAndObserve: {m}.
			self cleanUp: {m} ]
		displayingProgress: 'Reducing inputs (' , aListOfMethods size asString , ')'.
	links do: #uninstall.
	
	^ aListOfMethods
		select: [ :s | selectedMethods includes: s selector ]
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> reduceMethodsOld: aListOfMethods [
	| nodesToMutate |
	aListOfMethods ifEmpty: [ ^ aListOfMethods ].
	nodesToMutate := (uncovered collect: [ :u | u mutant originalMethod ])
		removeDuplicates.
	links := OrderedCollection new.
	[ self makeTestClassWith: aListOfMethods.
	self installMetaLinkTo: nodesToMutate.
	self runTestClassAndObserve: aListOfMethods ]
		ensure: [ links do: #uninstall.
			self cleanUp: aListOfMethods ].
	^ aListOfMethods
		select: [ :s | selectedMethods includes: s selector ]
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> runTestClassAndObserve: aListOfMethods [
	selectedMethods
		addAll:
			((testClass testSelectors
				select: [ :m | aListOfMethods anySatisfy: [ :z | z selector = m ] ])
				select: [ :sel | 
					covered := false.
					[ testClass run: sel ]
						valueWithin: config testRunTimeOutMult * testRunTimeoutMillis
						onTimeout: [ covered := false ].
					covered ])
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> uninstallMetaLinkTo: nodeToMutate [
	nodeToMutate
		do: [ :node | 
			node ast links
				select: [ :metalink | metalink metaObject == self ]
				thenDo: [ :metalink |  node removeLink: metalink ] ]
]
