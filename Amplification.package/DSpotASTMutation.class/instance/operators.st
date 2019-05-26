accessing
operators
	^ operators ifNil: [ operators := self class subclasses collect: [ :op | op new ] ]