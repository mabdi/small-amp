Class {
	#name : #SAUniqLiteralsInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SAUniqLiteralsInputAmplifier >> amplifyInputs [
	| aMethodAST results literals |
	aMethodAST := SAASTHelper new
		parsedMethodFrom: testMethodModel testMethod.
	literals := self getAllLiterals: aMethodAST.
	results := OrderedCollection new.
	literals
		keysAndValuesDo: [ :type :set | 
			set size > 1 ifTrue:
			[results
				addAll:
					(set
						collect: [ :v | self transform: aMethodAST copy type: type value: v ])] ].
	^ results collect: #formattedCode
]

{ #category : #removing }
SAUniqLiteralsInputAmplifier >> getAllLiterals: aMethodAST [
	| nodes result |
	nodes := (aMethodAST allChildren select: #isLiteralNode)
		reject: #isLiteralArray.
	result := Dictionary new.
	nodes
		do: [ :n | 
			result at: n value class ifAbsentPut: [ Set new ].
			(result at: n value class) add: n value ].
	^ result
]

{ #category : #'as yet unclassified' }
SAUniqLiteralsInputAmplifier >> namingPrefix [
	^ 'U'
]

{ #category : #removing }
SAUniqLiteralsInputAmplifier >> transform: aMethodAST type: type value: value [
	| nodes |
	nodes := ((aMethodAST allChildren select: #isLiteralNode)
		reject: #isLiteralArray) select: [ :n | n value class = type ].
	nodes
		do:
			[ :n | n parent replaceNode: n withNode: (RBLiteralValueNode value: value) ].
	^ aMethodAST
]
