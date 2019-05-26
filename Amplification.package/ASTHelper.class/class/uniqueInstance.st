instance creation
uniqueInstance
	^ instance ifNil: [ instance := self new ]