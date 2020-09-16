Class {
	#name : #SAObjectInstantiationExtractor,
	#superclass : #Object,
	#instVars : [
		'testClass',
		'l',
		'linkAssignments',
		'patterns'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #running }
SAObjectInstantiationExtractor >> executeAfterAssignmentNode: theNode context: theContext object: theObject [
	| val argVars instVars tempVars leftHandSide samples |
	"skip x:= 10"
	theNode value isLiteralNode & theNode value isLiteralArray not
		ifTrue: [ ^ self ].
	theNode value isVariable
		ifTrue: [ ^ self ].
	instVars := theNode value allVariables select: #isInstance.
	tempVars := (theNode value allVariables select: #isTemp)
		reject: #isArgument.
	argVars := theNode value allVariables select: #isArgument.
	samples := Dictionary new.
	instVars := instVars
		collect: [ :v | 
			val := theObject instVarNamed: v name.
			val isLiteral
				ifTrue: [ samples at: v name put: val ].
			v name -> val class ].
	tempVars := tempVars
		collect: [ :v | 
			val := theContext tempNamed: v name.
			val isLiteral
				ifTrue: [ samples at: v name put: val ].
			v name -> val class ].
	theNode variable isTemp
		ifTrue: [ leftHandSide := theContext tempNamed: theNode variable name ].
	theNode variable isInstance
		ifTrue: [ leftHandSide := theObject instVarNamed: theNode variable name ].
	leftHandSide ifNil: [ "self halt" ].
	patterns at: leftHandSide class name ifAbsentPut: [ Set new ].
	(patterns at: leftHandSide class name)
		add:
			{(#node -> theNode value copy).
			(#instVars -> instVars asDictionary).
			"(#argVars -> argVars asDictionary)."
			(#samples -> samples).
			(#tempVars -> tempVars asDictionary)} asDictionary
]

{ #category : #initialization }
SAObjectInstantiationExtractor >> initialize [ 
	patterns := Dictionary new.
]

{ #category : #running }
SAObjectInstantiationExtractor >> installMetalinks [
	"self flag: #todo	arguments in message sends"

	| methods |
	linkAssignments
		ifNil: [ linkAssignments := MetaLink new
				metaObject: self;
				control: #after;
				selector: #executeAfterAssignmentNode:context:object:;
				arguments: #(node context object);
				yourself ].
	methods := testClass methods collect: #ast"testClass allTestSelectors
		collect: [ :sel | (testClass lookupSelector: sel) ast ]".
	methods
		do: [ :method | 
			(method allChildren select: [ :node | node isAssignment ])
				do: [ :node | node link: linkAssignments ] ]
]

{ #category : #accessing }
SAObjectInstantiationExtractor >> patterns [
	^ patterns
]

{ #category : #running }
SAObjectInstantiationExtractor >> run [
	[self installMetalinks.
	self runTestClass.]  ensure: [ self uninstallMetalinks ]
	
]

{ #category : #'as yet unclassified' }
SAObjectInstantiationExtractor >> runTestClass [
	"If test throws any Exception, most probabily it's a malformed test. don't waste your time with it"
	testClass buildSuite run.
	^ [ [ "testClass buildSuite run" ]
		on: Exception
		do: [ :x | 
			x isResumable
				ifTrue: [ x resume ]
				ifFalse: [ nil ] ] ]
		valueWithin: 3000 milliSeconds
		onTimeout: [ nil ]
]

{ #category : #accessing }
SAObjectInstantiationExtractor >> testClass [
	^ testClass
]

{ #category : #accessing }
SAObjectInstantiationExtractor >> testClass: anObject [ 
	testClass := anObject 
]

{ #category : #running }
SAObjectInstantiationExtractor >> uninstallMetalinks [
	linkAssignments uninstall 
]
