Class {
	#name : #SAVariableTypeProfiler,
	#superclass : #Object,
	#instVars : [
		'testMethods',
		'testClass',
		'config',
		'variablesTypes'
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
	^ MetaLink new
		metaObject: self;
		control: #before;
		selector: #executeBeforeNode:value:;
		arguments: #(node value);
		yourself
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
SAVariableTypeProfiler >> installMetaLinksOnMethod: method [
	method ast allChildren
		select: #isVariable
		thenDo: [ :node | 
			(node links anySatisfy: [ :any | any metaObject isKindOf: self class ])
				ifTrue: [ self error: 'Sth is wrong' ].
			node link: self buildMetalink ]
]

{ #category : #running }
SAVariableTypeProfiler >> run [
	| generatedClass |
	generatedClass := self astHelper
		buildTestClassWith: testMethods
		using: testClass.
	(generatedClass methods select: #isTestMethod)
		do: [ :method | self installMetaLinksOnMethod: method ].
	generatedClass suite run.
	self cleanUp: generatedClass
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

{ #category : #accessing }
SAVariableTypeProfiler >> variablesTypes [
	^ variablesTypes ifNil: [ variablesTypes := Dictionary new ]
]

{ #category : #'instance creation' }
SAVariableTypeProfiler >> with: aConfig [
	self initialize.
	config := aConfig
]
