Class {
	#name : #SARemoveInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SARemoveInputAmplifier >> amplifyInputs [
| results aMethodAST |
	aMethodAST := SAGenericMethods new parsedMethodFrom: testMethodModel testMethod.
	results := OrderedCollection new.
	aMethodAST statements size < 2
		ifTrue: [ ^ results ].
	aMethodAST statements
		doWithIndex:
			[ :statement :index | results add: (self applyMessageRemove: index on: aMethodAST) ].
	^ results
]

{ #category : #running }
SARemoveInputAmplifier >> applyMessageRemove: index on: aMethod [
	| empty mClone theCode |
	empty := RBParser parseExpression: ''.
	mClone := aMethod copy.
	mClone statements at: index put: empty.
	theCode := mClone formattedCode.
	(theCode includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
	^ theCode
]

{ #category : #'as yet unclassified' }
SARemoveInputAmplifier >> namingPrefix [
	^ 'R'
]
