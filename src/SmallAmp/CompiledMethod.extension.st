Extension { #name : #CompiledMethod }

{ #category : #'*SmallAmp' }
CompiledMethod >> smallAmpIsAccessor [
	" code from MethodClassifier>>#classifyAccessor:"

	| names selector |
	names := self methodClass allInstVarNames.
	selector := self selector.
	(selector endsWith: ':')
		ifTrue: [ "selector might be a setter" selector := selector allButLast ].
	(names includes: selector)
		ifFalse: [ ^ false ].
	^ true
]
