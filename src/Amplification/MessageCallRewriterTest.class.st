Class {
	#name : #MessageCallRewriterTest,
	#superclass : #TestCase,
	#instVars : [
		'targetNodes',
		'visitor',
		'node'
	],
	#category : #'Amplification-Tests'
}

{ #category : #running }
MessageCallRewriterTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
visitor := MessageCallRewriter new
	
]

{ #category : #tests }
MessageCallRewriterTest >> testAddTemporaryVariables [
	node := RBParser parseMethod: 'foo ^ 1'.
	visitor addTemporaryVariables: 3 to: node.
	self
		assert: ((GeneralHelper renameTempVars: node formattedCode) includesSubstring: '| tmp1 tmp2 tmp3 |')
]

{ #category : #tests }
MessageCallRewriterTest >> testAddTemporaryVariables1 [
	node := RBParser parseMethod: 'foo |a b c | ^ 1'.
	visitor addTemporaryVariables: 3 to: node.
	self
		assert: ((GeneralHelper renameTempVars: node formattedCode) includesSubstring: '| a b c tmp1 tmp2 tmp3 |')
]

{ #category : #tests }
MessageCallRewriterTest >> testConvertToAssignment1 [
	node := RBParser parseMethod: 'foo a:=1'.
	visitor doYourJob: node.
	
	self
		assert: node formattedCode
		equals:
			'foo
	a := 1'
]

{ #category : #tests }
MessageCallRewriterTest >> testConvertToAssignment2 [
	node := RBParser parseMethod: 'foo a:=1. Array with:1'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node formattedCode)
		equals:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array with: 1'
]

{ #category : #tests }
MessageCallRewriterTest >> testConvertToAssignment3 [
	node := RBParser parseMethod: 'foo a:= 1. Array with:1;with:2'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node formattedCode)
		equals:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array
		with: 1;
		with: 2'
]

{ #category : #tests }
MessageCallRewriterTest >> testConvertToAssignment4 [
	node := RBParser parseMethod: 'foo a:= foo bar. Array with:1;with:2'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node formattedCode)
		equals:
			'foo
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2'
]

{ #category : #tests }
MessageCallRewriterTest >> testConvertToAssignment5 [
	node := RBParser parseMethod: 'foo foo bar. Array with:1;with:2'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node formattedCode)
		equals:
			'foo
	| tmp1 tmp2 |
	tmp1 := foo bar.
	tmp2 := Array
		with: 1;
		with: 2'
]

{ #category : #tests }
MessageCallRewriterTest >> testFunction1 [
	node := RBParser parseMethod: 'foo a:=1'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 0
]

{ #category : #tests }
MessageCallRewriterTest >> testFunction2 [
	node := RBParser parseMethod: 'foo a:=1. Array with:1'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 1
]

{ #category : #tests }
MessageCallRewriterTest >> testFunction3 [
	node := RBParser parseMethod: 'foo a:= 1. Array with:1;with:2'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 1
]

{ #category : #tests }
MessageCallRewriterTest >> testFunction4 [
	node := RBParser parseMethod: 'foo a:= foo bar. Array with:1;with:2'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 1
]

{ #category : #tests }
MessageCallRewriterTest >> testFunction5 [
	node := RBParser parseMethod: 'foo foo bar. Array with:1;with:2'.
	visitor visitNode: node.
	self assert: visitor targetNodes size equals: 2
]
