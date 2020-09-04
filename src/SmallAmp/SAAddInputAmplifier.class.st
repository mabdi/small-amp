Class {
	#name : #SAAddInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#instVars : [
		'variableTypes'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SAAddInputAmplifier >> amplifyInputs [
	| results aMethodAST |
	self profileVariableTypes.
	aMethodAST := SAASTHelper new
		parsedMethodFrom: testMethodModel testMethod.
	results := OrderedCollection new.
	aMethodAST statements
		doWithIndex:
			[ :statement :index | results addAll: (self applyMessageAdd: index on: aMethodAST) ].
	^ results
]

{ #category : #removing }
SAAddInputAmplifier >> applyMessageAdd: index on: aMethod [
	| newStatements statement mClone theCode results |
	results := OrderedCollection new.
	statement := aMethod statements at: index.
	(self checkSafeToAddAfter: statement)
		ifFalse: [ ^ results ].
	newStatements := self generateNewStatementsAfter: statement.
	results := newStatements
		collect: [ :stmt | 
			mClone := aMethod copy.
			mClone statements add: stmt afterIndex: index.
			theCode := mClone formattedCode.
			(theCode includesSubstring: '<an unprintable nonliteral value>')
				ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
			results add: theCode ].
	
	^ results
]

{ #category : #removing }
SAAddInputAmplifier >> checkSafeToAddAfter: statement [
	| msg key|

	msg := statement.
	statement isAssignment
		ifTrue: [ msg := statement value ].
	msg isMessage
		ifFalse: [ ^ false ].
	msg receiver isVariable
		ifFalse: [ ^ false ].
			key := testMethodModel selector , ':' , msg receiver name.
	^ testMethodModel testTargets
		anySatisfy: [ :c | 
			variableTypes
				at: key
				ifPresent: [ :c2 | c2 = c | (c2 inheritsFrom: c) | (c2 = c class) ]
				ifAbsent: [ false ] ]
]

{ #category : #removing }
SAAddInputAmplifier >> createMessageNodeFor: method type: class reveiver: aName [
	| valueNodes |
	valueNodes := OrderedCollection new.
	valueNodes
		addAll:
			((1 to: method numArgs)
				collect: [ :i | 
					(self
						getArgumentNodeFor: '#' , class name , '#' , method selector , '#' , i asString)
						ifNil: [ ^ nil ] ]).
	^ RBMessageNode
		receiver: (RBVariableNode named: aName)
		selector: method selector
		arguments: valueNodes
]

{ #category : #removing }
SAAddInputAmplifier >> generateNewStatementsAfter: statement [
	| msg nodes returnVal |
	statement isAssignment
		ifTrue: [ msg := statement value.
			returnVal := statement variable ].
	statement isMessage
		ifTrue: [ msg := statement ].
	nodes := OrderedCollection new. 
	nodes addAll: (self nodesFor: msg receiver name).
	returnVal  ifNotNil: [nodes addAll: (self nodesFor: returnVal name)].
	nodes := nodes reject: #isNil.
	^ nodes
]

{ #category : #'as yet unclassified' }
SAAddInputAmplifier >> getArgumentNodeFor: aKey [
	config profiler samples
		at: aKey
		ifPresent: [ :aSet | ^ RBLiteralValueNode value: aSet atRandom ]
		ifAbsent: [ ^ config profiler profile
				at: aKey
				ifPresent: [ :aClass | 
					^ RBMessageNode
						receiver: (RBVariableNode named: aClass name)
						selector: #new ]
				ifAbsent: [ ^ nil ] ]
]

{ #category : #testing }
SAAddInputAmplifier >> isNotSafeToSelect: method [
	^ {#private. #deprecated} includes: method protocol	"#initialization ."
]

{ #category : #'as yet unclassified' }
SAAddInputAmplifier >> namingPrefix [
	^ 'A'
]

{ #category : #private }
SAAddInputAmplifier >> nodesFor: variableName [
	| theType methods |
	theType := variableTypes
		at: testMethodModel selector , ':' , variableName
		ifAbsent: [nil class].
	methods := theType methods reject: [ :m | self isNotSafeToSelect: m ].
	^ methods
		collect:
			[ :m | self createMessageNodeFor: m type: theType reveiver: variableName ]
]

{ #category : #removing }
SAAddInputAmplifier >> profileVariableTypes [
	variableTypes := (SAVariableTypeProfiler initializeWith: config)
		testMethods: {testMethodModel testMethod};
		testClass: testMethodModel testClass;
		run;
		variablesTypes
]
