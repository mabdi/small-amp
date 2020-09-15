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
		control: #after;
		selector: #executeAfterNode:context:object:;
		arguments: #(node node node);
		yourself.
	links add: l.
	^ l
]

{ #category : #removing }
SAVariableTypeProfiler >> buildMetalinkStartMethod [
	| l |
	l := MetaLink new
		metaObject: self;
		control: #after;
		selector: #executeStartMethodNode:object:;
		arguments: #(node object);
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
SAVariableTypeProfiler >> executeAfterNode: node context: theContext [
	self
		executeAfterNode: node
		context: theContext
		object: theContext receiver
]

{ #category : #removing }
SAVariableTypeProfiler >> executeAfterNode: node context: theContextFake object: theObjectFake [
	| theObject type theContext |
	"the context is not passed for an unknown reason. :("
	theContext := thisContext sender.
	theObject := theContext receiver.
	[self halt.
	node isGlobal
		ifTrue: [ type := self class environment at: node name ].
	node isTemp
		ifTrue: [ type := theContext tempNamed: node name ].
	node isInstance
		ifTrue: [ type := theObject instVarNamed: node name ].
	type
		ifNotNil: [ self variablesTypes
				at: node methodNode selector , ':' , node name
				put: type ]] on: Error do: [ :x | self halt ] 
]

{ #category : #'as yet unclassified' }
SAVariableTypeProfiler >> executeAfterNode: node value: val [
	[ val class inheritsFrom: Object ]
		on: Error
		do: [ ^ self ].
	self halt.
	self variablesTypes
		at: node methodNode selector , ':' , node name
		put: val class
]

{ #category : #removing }
SAVariableTypeProfiler >> executeBeforeNode: node value: val [
	node isRead
		ifFalse: [ ^ self ].
	[ val class inheritsFrom: Object ]  on: Error do: [ ^ self ].
	self variablesTypes
		at: node methodNode selector , ':' , node name
		put: val class
]

{ #category : #removing }
SAVariableTypeProfiler >> executeStartMethodNode: node object: anObject [
	
	anObject class allInstVarNames
		do: [ :instVar | 
			self variablesTypes
				at: node methodNode selector , ':' , instVar , ':inst'
				put: (anObject instVarNamed: instVar) class ]
]

{ #category : #removing }
SAVariableTypeProfiler >> initialize [ 
	links := OrderedCollection new
]

{ #category : #removing }
SAVariableTypeProfiler >> installMetaLinksOnMethod: method [
	method ast body link: self buildMetalinkStartMethod.
	method ast allChildren
		select: #isVariable
		thenDo:
			[ :node | "(node links anySatisfy: [ :any | any metaObject isKindOf: self class ])
				ifTrue: [ self error: 'Sth is wrong' ]." node link: self buildMetalink ]
]

{ #category : #running }
SAVariableTypeProfiler >> run [
	| generatedClass |
	[ generatedClass := self astHelper
		buildTestClassWith: testMethods
		using: testClass.
	(generatedClass methods select: #isTestMethod)
		do: [ :method | self installMetaLinksOnMethod: method ].
	generatedClass suite run.
	[ "generatedClass suite run" ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ self error: 'variable profiling timeout' ] ]
		ensure: [ links do: #uninstall.
			self cleanUp: generatedClass ]
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
