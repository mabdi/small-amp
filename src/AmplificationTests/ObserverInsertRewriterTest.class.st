Class {
	#name : #ObserverInsertRewriterTest,
	#superclass : #TestCase,
	#instVars : [
		'targetNodes',
		'node',
		'visitor'
	],
	#category : #AmplificationTests
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
		assert: node dump
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBLiteralValueNode value: 1). })'
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
		assert: node dump
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. } statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBLiteralValueNode value: 1). RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }). RBMessageNode receiver: (RBSelfNode named: #self) selector: #observe:name:id: arguments: {RBVariableNode named: #Array. RBLiteralValueNode value: #Array. RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBSelfNode named: #self) selector: #observeResult:receiver:selector:name:id: arguments: {RBVariableNode named: #tmp1. RBVariableNode named: #Array. RBLiteralValueNode value: #with:. RBLiteralValueNode value: #tmp1. RBLiteralValueNode value: 2. }. })'
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
		assert: node dump
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. } statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBLiteralValueNode value: 1). RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBCascadeNode messages: {RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 2. }. }). RBMessageNode receiver: (RBSelfNode named: #self) selector: #observe:name:id: arguments: {RBVariableNode named: #Array. RBLiteralValueNode value: #Array. RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBSelfNode named: #self) selector: #observeResult:receiver:selector:name:id: arguments: {RBVariableNode named: #tmp1. RBVariableNode named: #Array. RBLiteralValueNode value: #with:. RBLiteralValueNode value: #tmp1. RBLiteralValueNode value: 2. }. })'
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
		assert: node dump
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. } statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBMessageNode receiver: (RBVariableNode named: #foo) selector: #bar). RBMessageNode receiver: (RBSelfNode named: #self) selector: #observe:name:id: arguments: {RBVariableNode named: #foo. RBLiteralValueNode value: #foo. RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBSelfNode named: #self) selector: #observeResult:receiver:selector:name:id: arguments: {RBVariableNode named: #a. RBVariableNode named: #foo. RBLiteralValueNode value: #bar. RBLiteralValueNode value: #a. RBLiteralValueNode value: 2. }. RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBCascadeNode messages: {RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 2. }. }). RBMessageNode receiver: (RBSelfNode named: #self) selector: #observe:name:id: arguments: {RBVariableNode named: #Array. RBLiteralValueNode value: #Array. RBLiteralValueNode value: 3. }. RBMessageNode receiver: (RBSelfNode named: #self) selector: #observeResult:receiver:selector:name:id: arguments: {RBVariableNode named: #tmp1. RBVariableNode named: #Array. RBLiteralValueNode value: #with:. RBLiteralValueNode value: #tmp1. RBLiteralValueNode value: 4. }. })'
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
		assert: node dump
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. RBVariableNode named: #tmp2. } statements: {RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBMessageNode receiver: (RBVariableNode named: #foo) selector: #bar). RBMessageNode receiver: (RBSelfNode named: #self) selector: #observe:name:id: arguments: {RBVariableNode named: #foo. RBLiteralValueNode value: #foo. RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBSelfNode named: #self) selector: #observeResult:receiver:selector:name:id: arguments: {RBVariableNode named: #tmp1. RBVariableNode named: #foo. RBLiteralValueNode value: #bar. RBLiteralValueNode value: #tmp1. RBLiteralValueNode value: 2. }. RBAssignmentNode variable: (RBVariableNode named: #tmp2) value: (RBCascadeNode messages: {RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 2. }. }). RBMessageNode receiver: (RBSelfNode named: #self) selector: #observe:name:id: arguments: {RBVariableNode named: #Array. RBLiteralValueNode value: #Array. RBLiteralValueNode value: 3. }. RBMessageNode receiver: (RBSelfNode named: #self) selector: #observeResult:receiver:selector:name:id: arguments: {RBVariableNode named: #tmp2. RBVariableNode named: #Array. RBLiteralValueNode value: #with:. RBLiteralValueNode value: #tmp2. RBLiteralValueNode value: 4. }. })'
]
