as yet unclassified
testWithdraw_13_1
	| b tmp_7yZis9QYT21 tmp_q4CGrQXs6Q2 tmp_N5Baazim6N3 tmp_6PsfhN7D9V4 tmp_9KCsC4Frb51 tmp_6ADD9Xu4nC2 tmp_5JUaBTFwHf3 tmp_zXftF6sjKE4 tmp_K9cMGvZiEm5 |
	b := SmallBank new.
	self assert: b balance equals: 0.
	tmp_7yZis9QYT21 := b balance = 1.
	self assert: tmp_7yZis9QYT21 asString equals: 'false'.
	tmp_7yZis9QYT21 := b deposit: -1152921504606846976.
	tmp_q4CGrQXs6Q2 := tmp_7yZis9QYT21 balance = -1152921504606846976.
	self assert: tmp_q4CGrQXs6Q2 asString equals: 'true'.
	tmp_q4CGrQXs6Q2 := b balance = -1152921504606846976.
	tmp_N5Baazim6N3 := tmp_q4CGrQXs6Q2 asString = 'true'.
	self assert: tmp_N5Baazim6N3 asString equals: 'true'.
	tmp_N5Baazim6N3 := b withdraw: 30.
	tmp_6PsfhN7D9V4 := tmp_N5Baazim6N3 balance = -1152921504606846976.
	self assert: tmp_6PsfhN7D9V4 asString equals: 'true'.
	tmp_6PsfhN7D9V4 := b balance = 70.
	tmp_9KCsC4Frb51 := tmp_6PsfhN7D9V4 asString = 'false'.
	self assert: tmp_9KCsC4Frb51 asString equals: 'true'