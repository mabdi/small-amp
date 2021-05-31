Class {
	#name : #SARotateLiteralsInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SARotateLiteralsInputAmplifier >> amplifyInputs [
	| aMethodAST results literals |
	aMethodAST := SAGenericMethods new
		parsedMethodFrom: testMethodModel testMethod.
	literals := self getAllLiterals: aMethodAST.
	results := OrderedCollection new.
	literals
		keysAndValuesDo: [ :type :vals | 
			vals size > 1
				ifTrue: [ 1 to: vals size - 1 do: [ :offset | 
						results
							add:
								(self
									transform: aMethodAST copy
									type: type
									values: vals
									startFrom: offset) ] ] ].
	^ results collect: #formattedCode
]

{ #category : #removing }
SARotateLiteralsInputAmplifier >> getAllLiterals: aMethodAST [
	| nodes result |
	nodes := (aMethodAST body allChildren select: #isLiteralNode)
		reject: #isLiteralArray.
	result := Dictionary new.
	nodes
		do: [ :n | 
			result at: n value class ifAbsentPut: [ OrderedCollection new ].
			(result at: n value class) add: n value ].
	^ result
]

{ #category : #'as yet unclassified' }
SARotateLiteralsInputAmplifier >> namingPrefix [
	^ 'O'
]

{ #category : #removing }
SARotateLiteralsInputAmplifier >> transform: aMethodAST type: type value: value [
	| nodes |
	nodes := ((aMethodAST body allChildren select: #isLiteralNode)
		reject: #isLiteralArray) select: [ :n | n value class = type ].
	nodes
		do:
			[ :n | n parent replaceNode: n withNode: (RBLiteralValueNode value: value) ].
	^ aMethodAST
]

{ #category : #removing }
SARotateLiteralsInputAmplifier >> transform: aMethodAST type: type values: vals startFrom: index [
	| nodes |
	nodes := ((aMethodAST body allChildren select: #isLiteralNode)
		reject: #isLiteralArray) select: [ :n | n value class = type ].
	nodes
		doWithIndex: [ :n :i | 
			n parent
				replaceNode: n
				withNode:
					(RBLiteralValueNode
						value: (vals at: 1 + ((i -1 + index) % vals size))) ].
	^ aMethodAST
]
