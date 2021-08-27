Extension { #name : #TestAsserter }

{ #category : #'*SmallAmp' }
TestAsserter >> assertMethodSourceCode: aSrc1 equals: aSrc2 [
	| ast1 ast2 |
	ast1 := RBParser parseMethod: aSrc1.
	ast2 := RBParser parseMethod: aSrc2.
	self assert: ast1 dump equals: ast2 dump
]

{ #category : #'*SmallAmp' }
TestAsserter >> assertMethodSourceCode: aSrc1 in: aList [
	| ast1 ast2 |
	self assert: (aList
		anySatisfy: [ :item | 
			ast1 := RBParser parseMethod: aSrc1.
			ast2 := RBParser parseMethod: item.
			ast1 dump = ast2 dump ])
]

{ #category : #'*SmallAmp' }
TestAsserter >> assertSourceCode: aSrc1 equals: aSrc2 [
	| ast1 ast2 |
	ast1 := RBParser parseExpression: aSrc1.
	ast2 := RBParser parseExpression: aSrc2.
	self assert: ast1 dump equals: ast2 dump
]

{ #category : #'*SmallAmp' }
TestAsserter >> assertSourceCode: aSrc1 in: aList [

	| ast1 ast2 |
	self assert: (aList anySatisfy: [ :item | 
			 ast1 := RBParser parseExpression: aSrc1.
			 ast2 := RBParser parseExpression: item.
			 ast1 dump = ast2 dump ])
]

{ #category : #'*SmallAmp' }
TestAsserter >> should: aBlock takeMoreThan: aDuration [
	"Evaluate aBlock and if it takes more than given duration
    to run we report a test failure. "

	<debuggerCompleteToSender>
	^ [aBlock value.
		self
				assert: false
				description: [ 'Block evaluation finished earlier than the expected <1p>'
						expandMacrosWith: aDuration ]]
		valueWithin: aDuration
		onTimeout: [  ]
]
