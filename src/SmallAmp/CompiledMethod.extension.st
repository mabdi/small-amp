Extension { #name : #CompiledMethod }

{ #category : #'*SmallAmp' }
CompiledMethod >> isMadeBySmallAmp [
	^ self hasPragmaNamed: SAASTHelper defaultPragma 
]

{ #category : #'*SmallAmp' }
CompiledMethod >> smallAmpIsAccessor [
	" code from MethodClassifier>>#classifyAccessor:"

	| names selector |
	self protocol = #testing
		ifTrue: [ ^ true ].
	self protocol = #accessing
		ifTrue: [ ^ true ].
	names := self methodClass allInstVarNames.
	selector := self selector.
	(selector endsWith: ':')
		ifTrue: [ "selector might be a setter" selector := selector allButLast ].
	(names includes: selector)
		ifTrue: [ ^ true ].
	^ false
]

{ #category : #'*SmallAmp' }
CompiledMethod >> smallAmpIsAssertion [
	^ self protocol = #asserting
]

{ #category : #'*SmallAmp' }
CompiledMethod >> smallAmpIsPure [
	^ self ast smallAmpIsPure
]
