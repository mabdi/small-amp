Class {
	#name : #MessageCallRewriterTest,
	#superclass : #TestCase,
	#instVars : [
		'targetNodes',
		'node'
	],
	#category : #AmplificationTests
}

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
