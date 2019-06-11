initialization
newGeneration
	self loggers
		do: [ :val | val add: OrderedCollection new ]