accessing
mutationOperators
	ops ifNil: [ ops := self class subclasses collect: [ :obj | obj new ] ]