Class {
	#name : #SAAddInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SAAddInputAmplifier >> amplifyInputs [
	| results aMethodAST |
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
	| statement mClone theCode results |
	results := OrderedCollection new.
	mClone := aMethod copy.
	self flag: #TODO. "Use profile to choose a method,"
	statement := mClone statements at: index.
	mClone statements add: statement afterIndex: index.
	theCode := mClone formattedCode.
	(theCode includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
	results add: theCode.
	^ results
]

{ #category : #'as yet unclassified' }
SAAddInputAmplifier >> namingPrefix [
	^ 'A'
]
