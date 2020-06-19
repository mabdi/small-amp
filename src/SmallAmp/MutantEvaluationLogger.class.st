Class {
	#name : #MutantEvaluationLogger,
	#superclass : #MutantEvaluation,
	#instVars : [
		'observation',
		'link',
		'testMethod'
	],
	#category : #'SmallAmp-MuTalk Extension'
}

{ #category : #'as yet unclassified' }
MutantEvaluationLogger >> getMetaLink [
	^ link := MetaLink new
		metaObject: self;
		selector: #observeMetaLink:context:value:object:;
		arguments: #(node context value object);
		control: #before;
		yourself
]

{ #category : #'as yet unclassified' }
MutantEvaluationLogger >> getMetaLinkMessage [
	^ link := MetaLink new
		metaObject: self;
		selector: #observeMetaLink:context:receiver:arguments:object:;
		arguments: #(node context receiver arguments object);
		control: #before;
		yourself
]

{ #category : #initialization }
MutantEvaluationLogger >> initialize [
	observation := SmallDictionary new
]

{ #category : #evaluation }
MutantEvaluationLogger >> installMetaLinkTo: aNode [
	self traceCr: 'Installing on: ' , aNode asString.
	aNode isMessage
		ifFalse: [ aNode link: self getMetaLink ]
		ifTrue: [ aNode isInlined
				ifTrue: [ self installMetaLinkTo: aNode receiver ]
				ifFalse: [ aNode link: self getMetaLinkMessage ] ]
]

{ #category : #evaluation }
MutantEvaluationLogger >> installMetaLinks [
	| ast |
	ast := (mutation originalClass >> mutation originalMethod selector)
		ast.
	self flag: #TODO.	"It only captures the first matching."
	RBParseTreeSearcher new
		matchesTree: mutation mutatedNode
			do: [ :aNode :answer | self installMetaLinkTo: aNode ];
		executeTree: ast
]

{ #category : #accessing }
MutantEvaluationLogger >> mutation [
	^ mutation
]

{ #category : #accessing }
MutantEvaluationLogger >> mutation: anObject [
	mutation := anObject
]

{ #category : #accessing }
MutantEvaluationLogger >> observation [
	^ observation
]

{ #category : #accessing }
MutantEvaluationLogger >> observation: anObject [
	observation := anObject
]

{ #category : #'as yet unclassified' }
MutantEvaluationLogger >> observeMetaLink: aNode context: aContext receiver: aReceiver arguments: args object: anObject [
	| vars val |
	
	vars := mutation nodeToMutate allVariables.
	(vars collect: #name)
		do: [ :aVar | 
			val := (anObject class hasInstVarNamed: aVar)
				ifTrue: [ anObject instVarNamed: aVar ]
				ifFalse: [ aContext tempNamed: aVar ].
			val isLiteral
				ifTrue: [ observation at: aVar put: val ] ].
	
]

{ #category : #'as yet unclassified' }
MutantEvaluationLogger >> observeMetaLink: aNode context: aContext value: aValue object: anObject [
	| vars val |
	
	vars := mutation nodeToMutate allVariables.
	(vars collect: #name)
		do: [ :aVar | 
			val := 
			(anObject class hasInstVarNamed: aVar) ifTrue: [anObject instVarNamed: aVar] ifFalse: [aContext tempNamed: aVar].
			val isLiteral
				ifTrue: [ observation at: aVar put: val ] ].
	
]

{ #category : #evaluation }
MutantEvaluationLogger >> removeMetaLinks [
	link ifNotNil: [ link uninstall]
]

{ #category : #evaluation }
MutantEvaluationLogger >> value [
	| testResults |
	self initializeCoverageResultIfNil.
	testResults := [ mutation install.
	self installMetaLinks.
	self testResults ]
		ensure: [ self removeMetaLinks.
			mutation uninstallDeep  ].
	^ MutantEvaluationResult
		for: mutation
		results: testResults
		producedBy: self
]
