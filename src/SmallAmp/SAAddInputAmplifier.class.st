Class {
	#name : #SAAddInputAmplifier,
	#superclass : #SAAbstractTypeSensitiveInputAmplifier,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAAddInputAmplifier class >> namingPostfix [
	^ 'A'
]

{ #category : #removing }
SAAddInputAmplifier >> amplifyInputs [
	| results aMethodAST |
	results := OrderedCollection new.
	aMethodAST := SAGenericMethods new
		parsedMethodFrom: testMethodModel testMethod.
	results addAll: (self applySetupMessageAddOn: aMethodAST).
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
			theCode
			"results add: theCode" ].
	^ results
]

{ #category : #removing }
SAAddInputAmplifier >> applySetupMessageAddOn: aMethodAST [
	| nodes instanceVars mClone theCode results |
	"check instance variables"
	nodes := OrderedCollection new.
	instanceVars := OrderedCollection new.
	(variableTypes at: SAVariableTypeProfiler instanceVariablesKey)
		do: [ :pair | 
			| type |
			type := pair value.
			(testMethodModel testTargets
				anySatisfy: [ :c | type = c | (type inheritsFrom: c) | (type = c class) ])
				ifTrue: [ instanceVars add: pair ] ].
	instanceVars
		do: [ :pair | 
			| methods |
			methods := pair value methods
				reject: [ :m | self isNotSafeToSelect: m ].
			nodes
				addAll:
					(methods
						collect:
							[ :m | self createMessageNodeFor: m type: pair value reveiver: pair key ]) ].
	nodes := nodes reject: #isNil.
	results := nodes
		collect: [ :stmt | 
			mClone := aMethodAST copy.
			mClone statements addFirst: stmt.
			theCode := mClone formattedCode.
			(theCode includesSubstring: '<an unprintable nonliteral value>')
				ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
			theCode ].
	^ results
]

{ #category : #removing }
SAAddInputAmplifier >> checkSafeToAddAfter: statement [
	| msg key |
	msg := statement.
	statement isAssignment
		ifTrue: [ msg := statement value ].
	msg isMessage
		ifFalse: [ ^ false ].
	msg receiver isVariable
		ifFalse: [ ^ false ].
	(self isVariableGlobal: msg receiver name)
		ifTrue: [ | c2 |
			c2 := self class environment at: msg receiver name.
			^ testMethodModel testTargets
				anySatisfy: [ :c | c2 = c | (c2 inheritsFrom: c) | (c2 = c class) ] ].
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
					aClass isMeta ifTrue: [ ^ nil ].
					^ aClass smallAmpDefaultInstantiation ]
				ifAbsent: [ ^ nil ] ]
]

{ #category : #testing }
SAAddInputAmplifier >> isNotSafeToSelect: method [
	^ {#private . #deprecated . #initialization}
		includes: method protocol
]

{ #category : #removing }
SAAddInputAmplifier >> isVariableGlobal: aName [
	aName first isLowercase
		ifTrue: [ ^ false ].
	self class environment at: aName ifPresent: [^ true] ifAbsent: [ ^ false ]
]

{ #category : #private }
SAAddInputAmplifier >> nodesFor: variableName [
	| theType methods |
	theType := variableTypes
		at: testMethodModel selector , ':' , variableName
		ifAbsent: [ nil class ].
	theType isMeta
		ifTrue: [ ^ {} ].
	theType = nil class
		ifTrue: [ ^ {} ].
	methods := theType methods reject: [ :m | self isNotSafeToSelect: m ].
	^ methods
		collect:
			[ :m | self createMessageNodeFor: m type: theType reveiver: variableName ]
]
