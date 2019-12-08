Extension { #name : #OrderedCollection }

{ #category : #'*Amplification' }
OrderedCollection >> collect: aBlock displayingProgress: aStringOrBlock [
	| newCollection |
	newCollection := self species new.
	self do: [ :each | newCollection add: (aBlock value: each) ] displayingProgress: aStringOrBlock.
	^ newCollection
]
