Class {
	#name : #SALiteralInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#instVars : [
		'mappings',
		'mutator',
		'aMethodAST'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SALiteralInputAmplifier >> allDynamicArrayNode [
	^ (aMethodAST allChildren select: #isDynamicArray)
		collect: [ :anArrayNode | 
			| mutants |
			mutants := mutator mutateArrayNode: anArrayNode.
	anArrayNode -> mutants.
			 ]
]

{ #category : #removing }
SALiteralInputAmplifier >> allLiteralArrayNode [
	^ (aMethodAST allChildren select: #isLiteralArray)
		collect: [ :aRBLiteralArrayNode | 
			| mutants |
			mutants := mutator mutateLiteralArrayNode: aRBLiteralArrayNode.
			aRBLiteralArrayNode -> mutants ]
]

{ #category : #removing }
SALiteralInputAmplifier >> allLiteralNodes [
	| allLiterals |
	allLiterals := aMethodAST allChildren select: #isLiteralNode.
	allLiterals := allLiterals
		reject: [ :node | node parent isLiteralArray and: [ node parent isForByteArray ]  ].
	^ allLiterals
		collect: [ :aLiteralNode | 
			| mutants |
			mutants := aLiteralNode value smallAmpMutateWith: mutator.
			mutants addAll: (self replaceWithASameType: aLiteralNode).
			aLiteralNode -> mutants ]
]

{ #category : #removing }
SALiteralInputAmplifier >> amplifyInputs [
	^ self amplifyInputsSource: testMethodModel testMethod.
	
]

{ #category : #removing }
SALiteralInputAmplifier >> amplifyInputsSource: testCode [
	| results |
	mutator := SALiteralMutator new.
	mappings := OrderedCollection new.
	aMethodAST := SAASTHelper new
		parsedMethodFrom: testCode.
	results := OrderedCollection new.
	mappings addAll: self allLiteralNodes.
	mappings addAll: self allLiteralArrayNode.
	mappings addAll: self allDynamicArrayNode.
	mappings
		do: [ :map | results addAll: (self replaceMappings: map on: aMethodAST) ].
	^ results
]

{ #category : #'as yet unclassified' }
SALiteralInputAmplifier >> namingPrefix [
	^ 'L'
]

{ #category : #'as yet unclassified' }
SALiteralInputAmplifier >> replaceMappings: map on: aMethod [
	| result |
	result := OrderedCollection new.
	map value
		do: [ :change | 
			| rewriter mClone theCode |
			mClone := aMethod copy.
			rewriter := RBParseTreeRewriter new.
			rewriter
				replaceTree: map key
				withTree: change
				when: [ :n | n start = map key start ].
			rewriter executeTree: mClone.
			theCode := mClone formattedCode.
			(theCode includesSubstring: '<an unprintable nonliteral value>')
				ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
			result add: theCode ].
	^ result
]

{ #category : #'as yet unclassified' }
SALiteralInputAmplifier >> replaceWithASameType: aLiteralNode [
	| sameTypeNodes |
	"aLiteralNode value isNumber
		ifFalse: [ ^ {} ]."
	sameTypeNodes := aMethodAST allChildren
		select:
			[ :n | n isLiteralNode and: [ n value class = aLiteralNode value class ] ].
	sameTypeNodes := sameTypeNodes
		reject: [ :x | x value = aLiteralNode value ].
	sameTypeNodes ifEmpty: [ ^ {} ].
	^ sameTypeNodes atRandom
]
