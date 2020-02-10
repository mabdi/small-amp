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
links := OrderedCollection new
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
	
	testClass := self astHelper
		buildTestClassWith: (aListOfMethods collect: #testMethod)
		using: aListOfMethods first testClass
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> reduceMethods: aListOfMethods [
	| nodesToMutate |
	aListOfMethods ifEmpty: [ ^ aListOfMethods ].
	nodesToMutate := (uncovered collect: [ :u | u mutant originalMethod ])
		removeDuplicates.
	[ self installMetaLinkTo: nodesToMutate.
	self makeTestClassWith: aListOfMethods.
	self runTestClassAndObserve ]
		ensure: [ links do: #uninstall ].
	^ aListOfMethods
		select: [ :s | selectedMethods includes: s selector ]
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> runTestClassAndObserve [
	selectedMethods := 
	testClass testSelectors
		select: [ :sel | 
			covered := false.
			testClass run: sel.
			covered
				]
]

{ #category : #'as yet unclassified' }
SAAliveMutationMethodReduction >> uninstallMetaLinkTo: nodeToMutate [
	nodeToMutate
		do: [ :node | 
			node ast links
				select: [ :metalink | metalink metaObject == self ]
				thenDo: [ :metalink |  node removeLink: metalink ] ]
]
