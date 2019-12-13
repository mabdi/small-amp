Class {
	#name : #MessageCallRewriterTest,
	#superclass : #TestCase,
	#instVars : [
		'targetNodes',
		'visitor',
		'node'
	],
	#category : #AmplificationTests
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
		assert: node dump
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBLiteralValueNode value: 1). })'
]

{ #category : #tests }
MessageCallRewriterTest >> testConvertToAssignment2 [
	node := RBParser parseMethod: 'foo a:=1. Array with:1'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node dump)
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. } statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBLiteralValueNode value: 1). RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }). })'
]

{ #category : #tests }
MessageCallRewriterTest >> testConvertToAssignment3 [
	node := RBParser parseMethod: 'foo a:= 1. Array with:1;with:2'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node dump)
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. } statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBLiteralValueNode value: 1). RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBCascadeNode messages: {RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 2. }. }). })'
]

{ #category : #tests }
MessageCallRewriterTest >> testConvertToAssignment4 [
	node := RBParser parseMethod: 'foo a:= foo bar. Array with:1;with:2'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node dump)
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. } statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBMessageNode receiver: (RBVariableNode named: #foo) selector: #bar). RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBCascadeNode messages: {RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 2. }. }). })'
]

{ #category : #tests }
MessageCallRewriterTest >> testConvertToAssignment5 [
	node := RBParser parseMethod: 'foo foo bar. Array with:1;with:2'.
	visitor doYourJob: node.
	self
		assert: (GeneralHelper renameTempVars: node dump)
		equals:
			'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. RBVariableNode named: #tmp2. } statements: {RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBMessageNode receiver: (RBVariableNode named: #foo) selector: #bar). RBAssignmentNode variable: (RBVariableNode named: #tmp2) value: (RBCascadeNode messages: {RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }. RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 2. }. }). })'
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

{ #category : #tests }
MessageCallRewriterTest >> testMessageCall2Rewriter [
	node := RBParser parseMethod: 'foo a:=1. Array with:1'.
	SAMethodNormalizingRewriter runWith: node.
	self
		assert: (GeneralHelper renameTempVars: node dump)
		equals:
		'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. } statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBLiteralValueNode value: 1). RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }). })'
]

{ #category : #tests }
MessageCallRewriterTest >> testMessageCall2Rewriter2 [
	node := RBParser parseMethod: 'foo a:=1. Array with:1;with:2'.
	SAMethodNormalizingRewriter runWith: node.
	self
		assert: (GeneralHelper renameTempVars: node dump)
		equals:
		'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. RBVariableNode named: #tmp2. } statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBLiteralValueNode value: 1). RBAssignmentNode variable: (RBVariableNode named: #tmp2) value: (RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 1. }). RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with: arguments: {RBLiteralValueNode value: 2. }). })'
]

{ #category : #tests }
MessageCallRewriterTest >> testMessageCall2Rewriter3 [
	node := RBParser parseMethod: 'foo a:=1. (Array with:1 with:2) size'.
	SAMethodNormalizingRewriter runWith: node.
	self
		assert: (GeneralHelper renameTempVars: node dump)
		equals:
		'RBMethodNode selector: #foo body: (RBSequenceNode temporaries: {RBVariableNode named: #tmp1. RBVariableNode named: #tmp2. } statements: {RBAssignmentNode variable: (RBVariableNode named: #a) value: (RBLiteralValueNode value: 1). RBAssignmentNode variable: (RBVariableNode named: #tmp2) value: (RBMessageNode receiver: (RBVariableNode named: #Array) selector: #with:with: arguments: {RBLiteralValueNode value: 1. RBLiteralValueNode value: 2. }). RBAssignmentNode variable: (RBVariableNode named: #tmp1) value: (RBMessageNode receiver: (RBVariableNode named: #tmp2) selector: #size). })'
]
