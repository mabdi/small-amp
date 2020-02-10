Class {
	#name : #SAVariableTypeProfiler,
	#superclass : #Object,
	#instVars : [
		'testMethods',
		'testClass',
		'config',
		'variablesTypes',
		'links'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #initialization }
SAVariableTypeProfiler class >> initializeWith: aConfig [
	^ self new with: aConfig
]

{ #category : #removing }
SAVariableTypeProfiler >> astHelper [
	^ SAASTHelper new
]

{ #category : #removing }
SAVariableTypeProfiler >> buildMetalink [
	| l |
	l := MetaLink new
		metaObject: self;
		control: #before;
		selector: #executeBeforeNode:value:;
		arguments: #(node value);
		yourself.
	links add: l.
	^ l
]

{ #category : #cleanup }
SAVariableTypeProfiler >> cleanUp: generatedClass [
	config debug
		ifFalse:
			[ self astHelper removeClass: generatedClass source: self class name ]
]

{ #category : #removing }
SAVariableTypeProfiler >> executeBeforeNode: node value: val [
	node isRead
		ifFalse: [ ^ self ].
	self variablesTypes at: node name put: val class
]

{ #category : #removing }
SAVariableTypeProfiler >> initialize [ 
	links := OrderedCollection new
]

{ #category : #removing }
SAVariableTypeProfiler >> installMetaLinksOnMethod: method [
	method ast allChildren
		select: #isVariable
		thenDo: [ :node | 
			"(node links anySatisfy: [ :any | any metaObject isKindOf: self class ])
				ifTrue: [ self error: 'Sth is wrong' ]."
			node link: self buildMetalink ]
]

{ #category : #running }
SAVariableTypeProfiler >> run [
	| generatedClass |
	[ generatedClass := self astHelper
		buildTestClassWith: testMethods
		using: testClass.
	(generatedClass methods select: #isTestMethod)
		do: [ :method | self installMetaLinksOnMethod: method ].
	generatedClass suite run ]
		ensure: [ links do: #uninstall.
			self cleanUp: generatedClass ].
		
]

{ #category : #accessing }
SAVariableTypeProfiler >> testClass [
	^ testClass
]

{ #category : #accessing }
SAVariableTypeProfiler >> testClass: anObject [
	testClass := anObject
]

{ #category : #accessing }
SAVariableTypeProfiler >> testMethods [
	^ testMethods
]

{ #category : #accessing }
SAVariableTypeProfiler >> testMethods: anObject [
	testMethods := anObject
]

{ #category : #removing }
SAVariableTypeProfiler >> uninstallMetaLinksOnMethod: method [
	method ast allChildren
		select: #isVariable
		thenDo: [ :node | 
			(node links select: [ :metalink | metalink metaObject == self ])
				do: [ :metalink | node removeLink: metalink ] ].
	"(self values do: [ :x | (x ast links select: #isNotNil)do: #uninstall ])
		"
	self
		assert:
			((method ast allChildren) flatCollect: #links)
				isEmpty
]

{ #category : #accessing }
SAVariableTypeProfiler >> variablesTypes [
	^ variablesTypes ifNil: [ variablesTypes := Dictionary new ]
]

{ #category : #'instance creation' }
SAVariableTypeProfiler >> with: aConfig [
	self initialize.
	config := aConfig
]
