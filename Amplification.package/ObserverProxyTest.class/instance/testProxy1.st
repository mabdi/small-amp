tests
testProxy1
	| b proxy |
	proxy := AbstractProxy new.
	proxy add:SmallBank >> #withdraw:.
	[ b := SmallBank new.
	b deposit: 10.
	b deposit: 20.
	b withdraw: 4.
	self assert: proxy observer equals: '' ]
		ensure: [ proxy destroy ]