Class {
	#name : #SARemoveMessageRewriter,
	#superclass : #Object,
	#instVars : [
		'testBody',
		'mappings'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'instance creation' }
SARemoveMessageRewriter class >> runWith: aTestBody [
	^ self new
		with: aTestBody;
		run
]

{ #category : #'instance creation' }
SARemoveMessageRewriter class >> with: aTestBody [
	^ self new
		with: aTestBody;
		yourself
]

{ #category : #running }
SARemoveMessageRewriter >> applyMessageRemove: index on: aMethod [
	| empty mClone theCode |
	empty := RBParser parseExpression: ''.
	mClone := aMethod copy.
	mClone statements at: index put: empty.
	theCode := mClone formattedCode.
	(theCode includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
	^ theCode
]

{ #category : #initialization }
SARemoveMessageRewriter >> initialize [
	mappings := OrderedCollection new.
]

{ #category : #running }
SARemoveMessageRewriter >> run [
	| results aMethodAST |
	aMethodAST := SAASTHelper new parsedMethodFrom: testBody.
	results := OrderedCollection new.
	aMethodAST statements size < 2
		ifTrue: [ ^ results ].
	aMethodAST statements
		doWithIndex:
			[ :statement :index | results add: (self applyMessageRemove: index on: aMethodAST) ].
	^ results
]

{ #category : #initialization }
SARemoveMessageRewriter >> with: aTestBody [
	self initialize.
	testBody := aTestBody
]
