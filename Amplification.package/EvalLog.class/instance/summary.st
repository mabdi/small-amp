initialization
summary
	^ {(#input_amp -> (self timeSum: #input_amp)).
	(#assert_amp -> (self timeSum: #assert_amp)).
	(#selection -> (self timeSum: #selection)).
	(#time_all -> (self timeSum: #time_all)).
	(#temps -> (self sum: #temps))} asDictionary