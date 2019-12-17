Class {
	#name : #SAMethodProfiler,
	#superclass : #Object,
	#instVars : [
		'theClass'
	],
	#classInstVars : [
		'classes'
	],
	#category : #'SmallAmp-Experiment'
}

{ #category : #adding }
SAMethodProfiler class >> addClassification: aMethod as: classification [
	(self classes at: aMethod name ifAbsentPut: Set new)
		add: classification
]

{ #category : #accessing }
SAMethodProfiler class >> classes [
	^ classes ifNil: [ classes := Dictionary new ]
]

{ #category : #classification }
SAMethodProfiler class >> classifyClass: aClass [
	self new classifyClass: aClass
]

{ #category : #classification }
SAMethodProfiler >> classifyClass: aClass [
	self theClass: aClass.
	self resetMethods.
	((aClass allSelectorsBelow: Object) asArray
		collect: [ :s | aClass lookupSelector: s ])
		select: [ :aSelector | self isOkToClassify: aSelector ]
		thenDo: [ :aMethod | self classifyMethod: aMethod ]
]

{ #category : #'as yet unclassified' }
SAMethodProfiler >> classifyMethod: aMethod [
	| methods |
	methods := ((aMethod senders )
		select:
			[ :aSenderMethod | aSenderMethod methodClass allSuperclasses includes: TestCase ])
		reject: [ :aSenderMethod | aSenderMethod ast hasPragmaNamed: #madeBySmallAmp ].
	methods ifEmpty: [ self classifyMethod: aMethod as: #unclassified ].
	methods
		do: [ :aSenderMethod | 
			| aSAFindAssertionsNodeVisitor |
			aSAFindAssertionsNodeVisitor := SAFindAssertionsNodeVisitor new
				initializeForSelector: aMethod selector.
			aSAFindAssertionsNodeVisitor visitNode: aSenderMethod ast.
			aSAFindAssertionsNodeVisitor isInsideAnAsserion
				ifTrue: [ self classifyMethod: aMethod as: #testing ].
			aSAFindAssertionsNodeVisitor isOutSideAnAsserion
				ifTrue: [ self classifyMethod: aMethod as: #updating ] ]
]

{ #category : #'as yet unclassified' }
SAMethodProfiler >> classifyMethod: aMethod as: classification [
	self class
		addClassification: aMethod
		as: classification
]

{ #category : #testing }
SAMethodProfiler >> isOkToClassify: aMethod [
	aMethod selector = #initialize ifTrue: [^ false].
	self class classes
		at: aMethod name
		ifPresent: [ ^ false ]
		ifAbsent: [ ^ true ]
]

{ #category : #initialization }
SAMethodProfiler >> resetMethods [
	theClass methods
		do: [ :item | self class classes removeKey: item name ifAbsent: [  ] ]
]

{ #category : #accessing }
SAMethodProfiler >> theClass: aClass [
	theClass := aClass
]
