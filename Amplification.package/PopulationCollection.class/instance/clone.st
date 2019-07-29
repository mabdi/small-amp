copying
clone 
	|result|
	result := self class new.
	self do: [ :item | result add: item clone ].
	^ result 