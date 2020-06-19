Class {
	#name : #SAResult,
	#superclass : #Object,
	#instVars : [
		'results'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #adding }
SAResult >> addResult: aResultItem for: aTestClass [
	results at: aTestClass name put: aResultItem 
]

{ #category : #adding }
SAResult >> initialize [
	results := Dictionary new.
	
]

{ #category : #adding }
SAResult >> markDown [
	^ String
		streamContents: [ :stream | 
			results anyOne markDownTitleOn: stream.
			results
				do: [ :rItem | 
					rItem markDownOn: stream.
					stream cr ] ]
]

{ #category : #adding }
SAResult >> results [
	^ results
]
