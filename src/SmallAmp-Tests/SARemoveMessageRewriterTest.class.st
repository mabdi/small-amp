"
A SARemoveMessageRewriterTest is a test class for testing the behavior of SARemoveMessageRewriter
"
Class {
	#name : #SARemoveMessageRewriterTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SARemoveMessageRewriterTest >> testDontRemove [
	| res |
	res := SARemoveMessageRewriter runWith: 'foo |a| a:=''Hello World'''.
	self
		assertEmpty: res
]

{ #category : #tests }
SARemoveMessageRewriterTest >> testRemove [
	| res |
	res := SARemoveMessageRewriter runWith: 'foo |a| a:=''Hello World''.a:= a,a'.
	self assertMethodSourceCode: (res at: 1) asString equals: 
			'foo
	| a |
	a := a , a'
]
