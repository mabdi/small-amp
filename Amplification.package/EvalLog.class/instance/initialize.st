initialization
initialize
	loggers := Dictionary new.
	loggers at: #input_amp put: OrderedCollection new.
	loggers at: #assert_amp put: OrderedCollection new.
	loggers at: #selection put: OrderedCollection new.
	loggers at: #time_all put: OrderedCollection new.
	loggers at: #temps put: OrderedCollection new