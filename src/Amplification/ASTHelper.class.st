Class {
	#name : #ASTHelper,
	#superclass : #Object,
	#instVars : [
		'instanceIds',
		'debug'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #'instance creation' }
ASTHelper class >> resetInstance [
	instance := nil
]

{ #category : #'instance creation' }
ASTHelper class >> uniqueInstance [
	^ instance ifNil: [ instance := self new ]
]

{ #category : #'method operations' }
ASTHelper >> buildTestClassWith: aCollection using: testClass [
	 ^ self buildTestClassWith: aCollection using: testClass final: false
]

{ #category : #'method operations' }
ASTHelper >> buildTestClassWith: aCollection using: testClass final: isFinal [
	| tempClass |
	tempClass := testClass superclass
		subclass: (testClass name asString , self getId asString) asSymbol
		instanceVariableNames: testClass instanceVariablesString
		classVariableNames: ''
		package: 'AmplificationTempClasses'.
	"#(#setUp #tearDown)
		do: [ :each | 
			testClass methods
				detect: [ :mtd | mtd selector = each ]
				ifFound: [ :item | tempClass compile: item sourceCode ] ]."
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
					'logs ^ smallamp_logs ifNil: [ smallamp_logs:= OrderedCollection new ]  '.
			tempClass
				compile: 'logFailure: aString self class logs add: aString'.
			tempClass
				compile:
					'assert: actual equals: expected description: description ^ self
		assert: actual = expected
		description: description'.
			tempClass
				compile:
					'deny: actual equals: expected description: description ^ self
		deny: actual = expected
		description: description'.
			tempClass
				compile:
					'should: aBlock notTakeMoreThan: aDuration description: description ^ aBlock
		valueWithin: aDuration
		onTimeout: [ self
				assert: false
				description: description ]'.
			tempClass
				compile:
					'should: aBlock takeMoreThan: aDuration description: description ^ aBlock
		valueWithin: aDuration
		onTimeout: [ self
				assert: true
				description: description ]'.
			tempClass compile: 'isLogging ^true' ].
	^ tempClass
]

{ #category : #cleanup }
ASTHelper >> cleanUp: aSourceCode [
	| mtd tmps rewriter |
	mtd := self parsedMethodFrom: aSourceCode.
	tmps := (mtd body temporaries
		select: [ :tmp | tmp name beginsWith: 'tmp_' ])
		reject: [ :tmp | 
			| visitor |
			visitor := NotUsedTempsVisitor new.
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
ASTHelper >> clearTempClasses [
	<script: 'ASTHelper uniqueInstance clearTempClasses '>
	
	('AmplificationTempClasses' asPackageIfAbsent:[^ true]) classes
		do: [ :item | item removeFromSystem ]
		displayingProgress: 'Clear temp amplified classes.'
]

{ #category : #removing }
ASTHelper >> convertAllToAssert: aMethod [
	^ (AssertTransform
		convertAllToAssert: aMethod parseTree
		transformers: (AssertTransform allSubclasses collect: [ :each | each new ]))
		formattedCode
]

{ #category : #accessing }
ASTHelper >> debug [
	^ debug ifNil: [ debug := false ]
]

{ #category : #debug }
ASTHelper >> debugFalse [
	<script: 'ASTHelper uniqueInstance debugFalse'>
	
	debug := false
]

{ #category : #debug }
ASTHelper >> debugTrue [
	<script: 'ASTHelper uniqueInstance debugTrue'>
	
	debug := true
]

{ #category : #'method operations' }
ASTHelper >> extractMethodName: aSourceCode [
	^ (self parsedMethodFrom: aSourceCode) selector
]

{ #category : #'method operations' }
ASTHelper >> extractMethodNameRegex: aSourceCode [
	| re |
	re := '^(\S+)(\:|\s).*' asRegex.
	re matchesPrefix: aSourceCode.
	^ ((re subexpression: 2) splitOn: ':') at: 1
]

{ #category : #private }
ASTHelper >> getId [
	instanceIds := instanceIds + 1.
	^ instanceIds
]

{ #category : #initialization }
ASTHelper >> initialize [ 

	instanceIds := 0
]

{ #category : #'method operations' }
ASTHelper >> parsedMethodFrom: aSourceCode [
	^ self parserClass parseMethod: aSourceCode
]

{ #category : #factory }
ASTHelper >> parserClass [
	^ RBParser
]

{ #category : #removing }
ASTHelper >> removeAssertions: aMethod [
	^ (AssertTransform
		removeAssertionsNoExtract: (self parsedMethodFrom: aMethod)
		transformers: (AssertTransform allSubclasses collect: [ :each | each new ]))
		formattedCode
]

{ #category : #removing }
ASTHelper >> removeAssertionsOld: aMethod [
	^ (AssertTransform
		removeAssertions: (self parsedMethodFrom: aMethod)
		transformers: (AssertTransform allSubclasses collect: [ :each | each new ]))
		formattedCode
]

{ #category : #removing }
ASTHelper >> removeClass: theClass source: sid [
	self debug 
		ifFalse: [ theClass removeFromSystem ]
]

{ #category : #'method operations' }
ASTHelper >> renameAndMoveClass: aClass name: aName package: aPackage [
	(self environment includesKey: aName)
		ifTrue: [^ self error: aName , ' already exists'].
	aClass renameSilently: aName.
	
]

{ #category : #'method operations' }
ASTHelper >> renameClass: aClass name: aName [
	aClass rename: aName
]

{ #category : #'method operations' }
ASTHelper >> renameMethodName: aSourceCode append: aText [
	| re first |
	re := self parsedMethodFrom: aSourceCode.
	first := (re selector splitOn: $:) at: 1.
	re selector: ((re selector splitOn: $:) at: 1 put: first , aText).
	^ re
]

{ #category : #'method operations' }
ASTHelper >> renameMethodNameRegex: aSourceCode append: aText [
	| mName |
	mName := self extractMethodNameRegex: aSourceCode.
	^ mName , aText
		, (aSourceCode copyFrom: mName size + 1 to: aSourceCode size)
]
