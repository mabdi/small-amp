tests
testInteger
	| res |
	res := DSpotASTMutationRewriter new doYourJob: 'foo |a| a:=10'.
	self assert: (res at: 1) asString equals: 'foo
	| a |
	a := 11'