"
A SALiteralMutationRewriterTest is a test class for testing the behavior of SALiteralMutationRewriter
"
Class {
	#name : #SALiteralMutationRewriterTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SALiteralMutationRewriterTest >> testBoolean [
	| res |
	res := SALiteralMutationRewriter runWith: 'foo |a| a:=false'.
	self assert: res asString equals: 'an OrderedCollection(''foo
	| a |
	a := true'')'
]

{ #category : #tests }
SALiteralMutationRewriterTest >> testInteger [
	| res |
	res := SALiteralMutationRewriter runWith: 'foo |a| a:=10'.
	self assert: (res at: 1) asString equals: 'foo
	| a |
	a := 11'
]

{ #category : #tests }
SALiteralMutationRewriterTest >> testString [
	| res |
	res := SALiteralMutationRewriter runWith:
		       'foo |a| a:=''Hello World'''.
	self assert: (res at: 1) asString equals: 'foo
	| a |
	a := '''''
]
