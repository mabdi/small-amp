"
A SALiteralMutationRewriterTest is a test class for testing the behavior of SALiteralMutationRewriter
"
Class {
	#name : #SALiteralMutationRewriterTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SALiteralMutationRewriterTest >> testArrayDouble [
	| res |
	res := SALiteralMutationRewriter
		runWith: 'foo |a| a set:{x}.b set:{x}'.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals: 'foo |a| a set:{}.b set:{x}'
]

{ #category : #tests }
SALiteralMutationRewriterTest >> testBoolean [
	| res |
	res := SALiteralMutationRewriter runWith: 'foo |a| a:=false'.
	self assert: res asString equals: 'an OrderedCollection(''foo
	| a |
	a := true'')'
]

{ #category : #tests }
SALiteralMutationRewriterTest >> testByteArray [
	| res |
	res := SALiteralMutationRewriter runWith: 'foo |a| a set:#[0 1 2 3]'.
	self assert: res size equals: 3. "ignore children"
	self
		assertMethodSourceCode: (res at: 1) asString
		equals: 'foo |a| a set:#[]'
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
SALiteralMutationRewriterTest >> testInteger2 [
	| res N |
	res := SALiteralMutationRewriter
		runWith: 'foo |a b c| a:=10.b:=20.c:=30'.
	N := 9.	"+1 -1 *2 /2 *-1 0 intMax intMin rand"
	self assert: res size equals: 3 * N.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals:
			'foo
	| a b c |
	a := 11.
	b:=20.
	c:=30'
]

{ #category : #tests }
SALiteralMutationRewriterTest >> testIntegerDouble [
	| res |
	res := SALiteralMutationRewriter runWith: 'foo |a| a:=10. b:=10'.
	self assertMethodSourceCode: (res at: 1) asString equals: 'foo |a| a:=11. b:=10'
]

{ #category : #tests }
SALiteralMutationRewriterTest >> testLiteralArray [
	| res |
	res := SALiteralMutationRewriter
		runWith: 'foo |a| a set:#(10 11 12 13)'.
	self assert: res size equals: 4 * 9 + 4.	"continue to mutation in children"
	self
		assertMethodSourceCode: (res at: 1) asString
		equals: 'foo |a| a set:#()'
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
