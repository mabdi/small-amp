tests
testString
	| res |
	res := DSpotASTMutationRewriter new
		doYourJob: 'foo |a| a:=''Hello World'''.
	self
		assert: (res at: 1) asString
		equals:
			'foo
	| a |
	a := '''''