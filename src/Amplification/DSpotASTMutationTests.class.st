Class {
	#name : #DSpotASTMutationTests,
	#superclass : #TestCase,
	#instVars : [
		'operators'
	],
	#category : #'Amplification-Tests'
}

{ #category : #tests }
DSpotASTMutationTests >> testBoolean [
	| res |
	res := DSpotASTMutationRewriter new doYourJob: 'foo |a| a:=false'.
	self assert: res asString equals: 'an OrderedCollection(''foo
	| a |
	a := true'')'
]

{ #category : #tests }
DSpotASTMutationTests >> testInteger [
	| res |
	res := DSpotASTMutationRewriter new doYourJob: 'foo |a| a:=10'.
	self assert: (res at: 1) asString equals: 'foo
	| a |
	a := 11'
]

{ #category : #tests }
DSpotASTMutationTests >> testString [
	| res |
	res := DSpotASTMutationRewriter new
		doYourJob: 'foo |a| a:=''Hello World'''.
	self
		assert: (res at: 1) asString
		equals:
			'foo
	| a |
	a := '''''
]
