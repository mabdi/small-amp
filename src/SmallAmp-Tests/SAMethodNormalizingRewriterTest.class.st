"
A SAMethodNormalizingRewriterTest is a test class for testing the behavior of SAMethodNormalizingRewriter
"
Class {
	#name : #SAMethodNormalizingRewriterTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SAMethodNormalizingRewriterTest >> astHelper [
	^ SAASTHelper new
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testCascade [
	| astBefore astAfter |
	astBefore := self astHelper parsedMethodFrom:
		             'foo a:=1. Array with:1;with:2'.
	astAfter := self astHelper parsedMethodFrom: 'foo
	| tmp_5XhFNhuDPT1 tmp_J5Gm96O7yf2 |
	a := 1.
	tmp_J5Gm96O7yf2 := Array with: 1.
	tmp_5XhFNhuDPT1 := Array with: 2'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self assert: (SAASTHelper new renameTempVars: astBefore dump) equals: (SAASTHelper new renameTempVars:astAfter dump)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testChain [
	| astBefore astAfter |
	astBefore := self astHelper parsedMethodFrom:
		             'foo a:=1. (Array with:1 with:2) size'.
	astAfter := self astHelper parsedMethodFrom: 'foo
	| tmp_uHdMrJYozl1 tmp_Ihz3cGorrB2 |
	a := 1.
	tmp_Ihz3cGorrB2 := Array with: 1 with: 2.
	tmp_uHdMrJYozl1 := tmp_Ihz3cGorrB2 size'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assert: (SAASTHelper new renameTempVars: astBefore dump)
		equals: (SAASTHelper new renameTempVars: astAfter dump)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testNoNormalize [
	| astBefore astAfter |
	astBefore := self astHelper parsedMethodFrom:
		             'foo a:=1. Array with:1'.
	astAfter := self astHelper parsedMethodFrom: 'foo
	| tmp_XU7VULfHBa1 |
	a := 1.
	tmp_XU7VULfHBa1 := Array with: 1'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assert: (SAASTHelper new renameTempVars: astBefore dump)
		equals: (SAASTHelper new renameTempVars: astAfter dump)
]
