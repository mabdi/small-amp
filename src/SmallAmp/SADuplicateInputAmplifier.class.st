Class {
	#name : #SADuplicateInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADuplicateInputAmplifier class >> namingPostfix [
	^ 'D'
]

{ #category : #removing }
SADuplicateInputAmplifier >> amplifyInputs [
	| results aMethodAST |
	aMethodAST := SAGenericMethods new
		parsedMethodFrom: testMethodModel testMethod.
	results := OrderedCollection new.
	aMethodAST statements
		doWithIndex:
			[ :statement :index | results add: (self applyMessageDuplicate: index on: aMethodAST) ].
	^ results
]

{ #category : #removing }
SADuplicateInputAmplifier >> applyMessageDuplicate: index on: aMethod [
	| statement mClone theCode |
	mClone := aMethod copy.
	statement := mClone statements at: index.
	statement isAssignment ifTrue: [ statement := statement value ].
	mClone statements add: statement afterIndex: index.
	theCode := mClone formattedCode.
	(theCode includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
	^ theCode
]
