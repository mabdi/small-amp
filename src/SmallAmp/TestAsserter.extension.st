Extension { #name : #TestAsserter }

{ #category : #'*SmallAmp' }
TestAsserter >> assertMethodSourceCode: aSrc1 equals: aSrc2 [
	| ast1 ast2 |
	ast1 := RBParser parseMethod: aSrc1.
	ast2 := RBParser parseMethod: aSrc2.
	self assert: ast1 dump equals: ast2 dump
]

{ #category : #'*SmallAmp' }
TestAsserter >> assertSourceCode: aSrc1 equals: aSrc2 [
	| ast1 ast2 |
	ast1 := RBParser parseExpression: aSrc1.
	ast2 := RBParser parseExpression: aSrc2.
	self assert: ast1 dump equals: ast2 dump
]
