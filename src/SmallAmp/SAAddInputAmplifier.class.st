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
	1 to: method numArgs do: [ :i | 
		valueNodes
			add:
				(RBLiteralValueNode value: (config profiler samples
					at: '#' , class name , '#' , method selector , '#' , i asString
					ifAbsent: [ ^ nil ]) atRandom) ].
	.		
	^ RBMessageNode
		receiver: (RBVariableNode named: aName)
		selector: method selector
		arguments: valueNodes
]

{ #category : #removing }
SAAddInputAmplifier >> generateNewStatementsAfter: statement [
	| msg theType methods nodes |
	statement isAssignment
		ifTrue: [ msg := statement value ].
	statement isMessage
		ifTrue: [ msg := statement ].
	theType := variableTypes at: testMethodModel selector , ':', msg receiver name.
	methods := theType methods
		reject: [ :m | msg selector = m selector or: [ self isNotSafeToSelect: m ] ].
	nodes := methods
		collect:
			[ :m | self createMessageNodeFor: m type: theType reveiver: msg receiver name ].
	nodes := nodes reject: #isNil.
	^ nodes
]

{ #category : #testing }
SAAddInputAmplifier >> isNotSafeToSelect: method [
	^ {"#initialization ." #private} includes: method protocol
]

{ #category : #'as yet unclassified' }
SAAddInputAmplifier >> namingPrefix [
	^ 'A'
]

{ #category : #removing }
SAAddInputAmplifier >> profileVariableTypes [
	variableTypes := (SAVariableTypeProfiler initializeWith: config)
		testMethods: {testMethodModel testMethod};
		testClass: testMethodModel testClass;
		run;
		variablesTypes
]
