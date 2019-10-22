Class {
	#name : #ObserverInsertRewriterTest,
	#superclass : #TestCase,
	#instVars : [
		'targetNodes',
		'node',
		'visitor'
	],
	#category : #'Amplification-Tests'
}

{ #category : #running }
ObserverInsertRewriterTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	visitor := ObserverInsertRewriter  new
]

{ #category : #tests }
ObserverInsertRewriterTest >> testInsertObservers1 [
	node := RBParser
		parseMethod:
			'foo
	a := 1'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	a := 1'
]

{ #category : #tests }
ObserverInsertRewriterTest >> testInsertObservers2 [
	node := RBParser
		parseMethod:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array with: 1'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array with: 1.
	self observe: Array name: #Array id: 1.
	self
		observeResult: tmp1
		receiver: Array
		selector: #with:
		name: #tmp1
		id: 2'
]

{ #category : #tests }
ObserverInsertRewriterTest >> testInsertObservers3 [
	node := RBParser
		parseMethod:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array
		with: 1;
		with: 2'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	| tmp1 |
	a := 1.
	tmp1 := Array
		with: 1;
		with: 2.
	self observe: Array name: #Array id: 1.
	self
		observeResult: tmp1
		receiver: Array
		selector: #with:
		name: #tmp1
		id: 2'
]

{ #category : #tests }
ObserverInsertRewriterTest >> testInsertObservers4 [
	node := RBParser
		parseMethod:
			'foo
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	| tmp1 |
	a := foo bar.
	self observe: foo name: #foo id: 1.
	self
		observeResult: a
		receiver: foo
		selector: #bar
		name: #a
		id: 2.
	tmp1 := Array
		with: 1;
		with: 2.
	self observe: Array name: #Array id: 3.
	self
		observeResult: tmp1
		receiver: Array
		selector: #with:
		name: #tmp1
		id: 4'
]

{ #category : #tests }
ObserverInsertRewriterTest >> testInsertObservers5 [
	node := RBParser
		parseMethod:
			'foo
	| tmp1 tmp2 |
	tmp1 := foo bar.
	tmp2 := Array
		with: 1;
		with: 2'.
	visitor doYourJob: node.
	self
		assert: node formattedCode
		equals:
			'foo
	| tmp1 tmp2 |
	tmp1 := foo bar.
	self observe: foo name: #foo id: 1.
	self
		observeResult: tmp1
		receiver: foo
		selector: #bar
		name: #tmp1
		id: 2.
	tmp2 := Array
		with: 1;
		with: 2.
	self observe: Array name: #Array id: 3.
	self
		observeResult: tmp2
		receiver: Array
		selector: #with:
		name: #tmp2
		id: 4'
]
