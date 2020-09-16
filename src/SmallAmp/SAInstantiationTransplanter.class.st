Class {
	#name : #SAInstantiationTransplanter,
	#superclass : #SAAbstractInputAmplifier,
	#instVars : [
		'variableTypes',
		'instantiationPatterns',
		'aMethodAST'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SAInstantiationTransplanter >> amplifyInputs [
	| results |
	self profileVariableTypes.
	results := OrderedCollection new.
	aMethodAST := SAASTHelper new
		parsedMethodFrom: testMethodModel testMethod.
	results addAll: self transplantInstanceVariables.
	results addAll: self transplantAssignments.
	^ results
]

{ #category : #'as yet unclassified' }
SAInstantiationTransplanter >> genNodeFromPattern: pattern assignTo: aName [
	| assignment existingTemps toAddTemps statements |
	statements := OrderedCollection new.
	assignment := RBAssignmentNode
		variable: (RBVariableNode named: aName)
		value: (pattern at: #node).
	existingTemps := aMethodAST body temporaries collect: #name.
	toAddTemps := (pattern at: #tempVars) keys
		reject: [ :v | existingTemps includes: v ].
	toAddTemps := toAddTemps collect: [ :t | RBVariableNode named: t ].
	(pattern at: #tempVars)
		keysAndValuesDo: [ :key :val | 
			| value |
			((pattern at: #samples) includesKey: key)
				ifTrue:
					[ value := RBLiteralValueNode value: ((pattern at: #samples) at: key) ]
				ifFalse: [ value := val smallAmpDefaultInstantiation ].
			statements
				add: (RBAssignmentNode variable: (RBVariableNode named: key) value: value) ].
	statements addLast: assignment.
	^ RBSequenceNode temporaries: toAddTemps statements: statements
]

{ #category : #accessing }
SAInstantiationTransplanter >> instantiationPatterns [
	^ instantiationPatterns
]

{ #category : #accessing }
SAInstantiationTransplanter >> instantiationPatterns: anObject [
	instantiationPatterns := anObject
]

{ #category : #'as yet unclassified' }
SAInstantiationTransplanter >> isInScope: aType [
			^ testMethodModel testTargets
				anySatisfy: [ :c | aType = c | (aType inheritsFrom: c) | (aType = c class) ]
]

{ #category : #'as yet unclassified' }
SAInstantiationTransplanter >> namingPrefix [
	^ 'T'
]

{ #category : #removing }
SAInstantiationTransplanter >> profileVariableTypes [
	variableTypes := (SAVariableTypeProfiler initializeWith: config)
		testMethods: {testMethodModel testMethod};
		testClass: testMethodModel testClass;
		run;
		variablesTypes
]

{ #category : #'as yet unclassified' }
SAInstantiationTransplanter >> transplantAssignments [
	| newMethod selectedPoints |
	selectedPoints := (aMethodAST body statements select: #isAssignment)
		select: [ :assignNode | 
			| key |
			key := ':'
				join:
					{aMethodAST selector.
					assignNode variable name}.
			variableTypes
				at: key
				ifPresent: [ :x | self isInScope: x ]
				ifAbsent: [ false ] ].
	^ selectedPoints
		flatCollect: [ :point | 
			| nodes index |
			index := point parent statements indexOf: point.
			nodes := self transplantVarName: point variable name.
			nodes
				collect: [ :node | 
					newMethod := aMethodAST copy.
					node temporaries
						do: [ :t | newMethod body addTemporaryNamed: t name ].
					node statements
						reverseDo: [ :s | newMethod body statements add: s afterIndex: index ].
					newMethod body statements removeAt: index.
					newMethod formattedCode ] ]
]

{ #category : #'as yet unclassified' }
SAInstantiationTransplanter >> transplantInstanceVariables [
	[ | newMethod inScopeVars |
	inScopeVars := (variableTypes
		at: SAVariableTypeProfiler instanceVariablesKey)
		select: [ :pair | self isInScope: pair value ].
	^ inScopeVars
		do: [ :pair | 
			newMethod := aMethodAST copy.
			newMethod body addFirst: [  ] ] ].
	^ {  }
]

{ #category : #'as yet unclassified' }
SAInstantiationTransplanter >> transplantVarName: aName [
	| type patterns |
	type := variableTypes at: (':' join: {aMethodAST selector. aName}).
	patterns := instantiationPatterns at: type asString ifAbsent: [ ^ {  } ]. 
	^ patterns collect: [ :p | self genNodeFromPattern: p assignTo: aName ] 
]
