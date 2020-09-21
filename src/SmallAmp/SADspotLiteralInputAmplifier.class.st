Class {
	#name : #SADspotLiteralInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#instVars : [
		'mappings',
		'aMethodAST'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SADspotLiteralInputAmplifier >> addARandomCharacterTo: aString [
	| x |
	x := aString size atRandom.
	^ (aString copyFrom: 1 to: x) , self characterSet atRandom asString
		, (aString copyFrom: x + 1 to: aString size)
]

{ #category : #removing }
SADspotLiteralInputAmplifier >> amplifyBooleans [
	| nodes |
	nodes := aMethodAST allChildren
		select: [ :n | 
			n isLiteralNode
				and: [ True = n value class | (False = n value class) ] ].
	mappings
		addAll:
			(nodes
				collect: [ :n | 
					n -> (RBLiteralValueNode value: n value not) ])
]

{ #category : #removing }
SADspotLiteralInputAmplifier >> amplifyInputs [
	| results |
	mappings := OrderedCollection new.
	aMethodAST := SAASTHelper new
		parsedMethodFrom: testMethodModel testMethod.
	self amplifyNumbers.
	self amplifyStrings.
	self amplifyBooleans.
	results := OrderedCollection new.
	mappings
		do: [ :map | results addAll: (self replaceMappings: map on: aMethodAST) ].
	^ results
	"
| nodes sameTypeNodes |
	nodes := mutator mutateNode: aLiteralNode.
	aLiteralNode value isNumber
		ifTrue: [ sameTypeNodes := aMethodAST allChildren
				select:
					[ :n | n isLiteralNode and: [ n value class = aLiteralNode value class ] ].
			sameTypeNodes reject: [ :x | x value = aLiteralNode value ].
			sameTypeNodes ifNotEmpty: [ nodes add: sameTypeNodes atRandom ] ].
	^ nodes"
]

{ #category : #removing }
SADspotLiteralInputAmplifier >> amplifyNumbers [
	| nodes sameTypeNodes half |
	nodes := aMethodAST allChildren
		select: [ :n | n isLiteralNode and: [ n value isNumber ] ].
	mappings
		addAll:
			(nodes
				flatCollect: [ :n | 
					sameTypeNodes := nodes reject: [ :n2 | n2 == n ].
					half := n value isInteger
						ifTrue: [ (n value / 2) asInteger ]
						ifFalse: [ (n value / 2) ].
					{(n -> (RBLiteralValueNode value: n value - 1)).
					(n -> (RBLiteralValueNode value: n value + 1)).
					(n -> (RBLiteralValueNode value: n value * 2)).
					(n -> (RBLiteralValueNode value: half)).
					(sameTypeNodes
						ifEmpty: [ nil ]
						ifNotEmpty: [ n -> (RBLiteralValueNode value: sameTypeNodes atRandom value) ])} ]).
	mappings := mappings reject: #isNil
]

{ #category : #removing }
SADspotLiteralInputAmplifier >> amplifyStrings [
	| nodes |
	nodes := aMethodAST allChildren
		select: [ :n | n isLiteralNode and: [ n value isString ] ].
	mappings
		addAll:
			(nodes
				flatCollect: [ :n | 
					{n->(RBLiteralValueNode value: (self addARandomCharacterTo: n value)).
					n->(RBLiteralValueNode
						value: (self removeARandomCharacterFrom: n value)).
					n->(RBLiteralValueNode
						value: (self replaceARandomCharacterFrom: n value)).
					n->(RBLiteralValueNode
						value: (self newRandomStringSameSize: n value))} ]).
	mappings := mappings reject: #isNil
]

{ #category : #'recursive descent' }
SADspotLiteralInputAmplifier >> characterSet [
	^ String
		streamContents: [ :stream | 
			Character alphabet putOn: stream.
			Character alphabet asUppercase putOn: stream.
			'0123456789' putOn: stream.
			'!@#$%^&*(){}\|''";:?/.>,<`~§±' putOn: stream.
			Character space putOn: stream.
			Character cr putOn: stream.
			Character tab putOn: stream ]
]

{ #category : #'as yet unclassified' }
SADspotLiteralInputAmplifier >> namingPrefix [
	^ 'L'
]

{ #category : #removing }
SADspotLiteralInputAmplifier >> newRandomStringSameSize: aString [
	^ (String new: aString size) collect: [ :each | self characterSet atRandom ]
]

{ #category : #removing }
SADspotLiteralInputAmplifier >> removeARandomCharacterFrom: aString [
	aString ifEmpty: [ ^ aString ].
	^ aString copyWithoutIndex: aString size atRandom
]

{ #category : #removing }
SADspotLiteralInputAmplifier >> replaceARandomCharacterFrom: aString [
	aString ifEmpty: [ ^ aString ].
	^ aString copy
		at: aString size atRandom put: self characterSet atRandom;
		yourself
]

{ #category : #'as yet unclassified' }
SADspotLiteralInputAmplifier >> replaceMappings: map on: aMethod [
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
