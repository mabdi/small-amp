tests
testProxy2
	| b proxy |
	proxy := AbstractProxy new.
	proxy add: SmallBank >> #withdraw:.
	proxy add: SmallBank >> #deposit:.
	[ b := SmallBank new.
	b deposit: 10.
	b deposit: 20.
	b withdraw: 4.
	self assert: proxy observer equals: '' ]
		ensure: [ proxy destory ]