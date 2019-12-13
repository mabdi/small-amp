Class {
	#name : #SAASTHelper,
	#superclass : #Object,
	#classInstVars : [
		'instanceId'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
SAASTHelper class >> instanceId [
	instanceId ifNil: [ instanceId:=0 ].
	instanceId := instanceId + 1.
	^ instanceId
]

{ #category : #'method operations' }
SAASTHelper >> buildTestClassWith: aCollection using: testClass [
	 ^ self buildTestClassWith: aCollection using: testClass final: false
]

{ #category : #'method operations' }
SAASTHelper >> buildTestClassWith: aCollection using: testClass final: isFinal [
	| tempClass |
	tempClass := testClass superclass
		subclass: (testClass name asString , self getId asString) asSymbol
		instanceVariableNames: testClass instanceVariablesString
		classVariableNames: ''
		package: 'AmplificationTempClasses'.
	(testClass methods reject: #isTestMethod)
		do: [ :item | tempClass compile: item sourceCode ].
	aCollection
		do: [ :item | 
			| ast |
			ast := self parsedMethodFrom: item.
			(ast hasPragmaNamed: #madeBySmallAmp)
				ifFalse: [ ast
						addPragma: (RBPragmaNode selector: #madeBySmallAmp arguments: {}) ].
			tempClass compile: ast formattedCode ].
	isFinal
		ifFalse: [ tempClass class addInstVarNamed: 'smallamp_logs'.
			tempClass class
				compile:
					'logs ^ smallamp_logs ifNil: [ smallamp_logs := OrderedCollection new ]  '.
			tempClass
				compile: 'logFailure: aString self class logs add: aString'.
			tempClass compile: 'isLogging ^true' ].
	^ tempClass
]

{ #category : #cleanup }
SAASTHelper >> cleanUp: aSourceCode [
	| mtd tmps rewriter |
	mtd := self parsedMethodFrom: aSourceCode.
	tmps := (mtd body temporaries
		select: [ :tmp | tmp name beginsWith: 'tmp_' ])
		reject: [ :tmp | 
			| visitor |
			visitor := SANotUsedTempsVisitor new.
			visitor tmp_var: tmp name.
			mtd acceptVisitor: visitor.
			visitor used ].
	rewriter := RBParseTreeRewriter new.
	tmps
		do: [ :tmp | rewriter replace: tmp name , ' := ``@x' with: '``@x' ].
	rewriter executeTree: mtd.
	tmps do: [ :tmp | mtd body temporaries remove: tmp ].
	^ mtd formattedCode
]

{ #category : #cleanup }
SAASTHelper >> clearTempClasses [
	<script: 'ASTHelper new clearTempClasses '>
	('AmplificationTempClasses' asPackageIfAbsent: [ ^ true ]) classes
		do: [ :item | item removeFromSystem ]
		displayingProgress: 'Clear temp amplified classes.'
]

{ #category : #removing }
SAASTHelper >> convertAllToAssert: aMethod [
	^ (SAAssertTransform
		transformAllAsserts: aMethod parseTree
		)
		formattedCode
]

{ #category : #'method operations' }
SAASTHelper >> extractMethodName: aSourceCode [
	^ (self parsedMethodFrom: aSourceCode) selector
]

{ #category : #'method operations' }
SAASTHelper >> extractMethodNameRegex: aSourceCode [
	| re |
	re := '^(\S+)(\:|\s).*' asRegex.
	re matchesPrefix: aSourceCode.
	^ ((re subexpression: 2) splitOn: ':') at: 1
]

{ #category : #private }
SAASTHelper >> getId [
	^ self class instanceId
]

{ #category : #'method operations' }
SAASTHelper >> parsedMethodFrom: aSourceCode [
	^ self parserClass parseMethod: aSourceCode
]

{ #category : #factory }
SAASTHelper >> parserClass [
	^ RBParser
]

{ #category : #removing }
SAASTHelper >> removeAssertions: aMethod [
	^ (SAAssertTransform
		   removeAllAsserts: (self parsedMethodFrom: aMethod)
		   )
		  formattedCode
]

{ #category : #removing }
SAASTHelper >> removeClass: theClass source: sid [
	theClass removeFromSystem
]

{ #category : #'method operations' }
SAASTHelper >> renameAndMoveClass: aClass name: aName package: aPackage [
	(self environment includesKey: aName)
		ifTrue: [^ self error: aName , ' already exists'].
	aClass renameSilently: aName.
	
]

{ #category : #'method operations' }
SAASTHelper >> renameClass: aClass name: aName [
	aClass rename: aName
]

{ #category : #'method operations' }
SAASTHelper >> renameMethodName: aSourceCode append: aText [
	| re first |
	re := self parsedMethodFrom: aSourceCode.
	first := (re selector splitOn: $:) at: 1.
	re selector: ((re selector splitOn: $:) at: 1 put: first , aText).
	^ re
]

{ #category : #'method operations' }
SAASTHelper >> renameMethodNameRegex: aSourceCode append: aText [
	| mName |
	mName := self extractMethodNameRegex: aSourceCode.
	^ mName , aText
		, (aSourceCode copyFrom: mName size + 1 to: aSourceCode size)
]
