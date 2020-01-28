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
SAMethodNormalizingRewriterTest >> testChain3NonArg [
	| astBefore codeAfter |
	astBefore := self astHelper parsedMethodFrom: 'foo a b c. d:= e f g'.
	codeAfter := 'foo
	| tmp_ga4aLsDFHd1 tmp_l1bQQaOaUi2 tmp_Nx36B1jZZ43 |
	tmp_l1bQQaOaUi2 := a b.
	tmp_ga4aLsDFHd1 := tmp_l1bQQaOaUi2 c.
	tmp_Nx36B1jZZ43 := e f.
	d := tmp_Nx36B1jZZ43 g'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assertMethodSourceCode: (SAASTHelper new renameTempVars: astBefore formattedCode)
		equals: (SAASTHelper new renameTempVars: codeAfter)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testDuplicateMessages [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom: 'foo | c |
	c := PolishCalculator new.
	c one.
	c two.
	c sub.
	c add.
	c add.'.
	astAfter := self astHelper
		parsedMethodFrom:
			'foo
	| c tmp_4i9DOj2lF61 tmp_NqD683Ca6d2 tmp_QzSdLqXCVx3 tmp_MAHhbR3cR04 tmp_cXmrihy6UX5 |
	c := PolishCalculator new.
	tmp_4i9DOj2lF61 := c one.
	tmp_NqD683Ca6d2 := c two.
	tmp_QzSdLqXCVx3 := c sub.
	tmp_MAHhbR3cR04 := c add.
	tmp_cXmrihy6UX5 := c add'.
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
