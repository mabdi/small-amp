tests
testShouldNotTakeMoreThan
	|g| g:=UUIDGenerator new.self
		should: [ 100000 timesRepeat: [ g next ] ]
		notTakeMoreThan: 1 second