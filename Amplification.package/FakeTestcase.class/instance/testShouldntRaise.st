tests
testShouldntRaise
	| file |
	file := File named: 'asdqhdjhakjhdkjasdjkhbasdjhbasdjhb.fake'.
	self shouldnt: [ file checkDoesNotExist ] raise: Error