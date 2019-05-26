tests
testBoolean
	| res |
	res := DSpotASTMutationRewriter new doYourJob: 'foo |a| a:=false'.
	self assert: res asString equals: 'an OrderedCollection(''foo
	| a |
	a := true'')'