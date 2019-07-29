tests
testProxyFix
	AbstractProxy new add: SmallBank >> #withdraw:.
	self
		assert: (SmallBank methodDict at: #withdraw:) class
		equals: MethodCallProxy.
	MethodCallProxy fixClass: SmallBank.
	self
		assert: (SmallBank methodDict at: #withdraw:) class
		equals: CompiledMethod