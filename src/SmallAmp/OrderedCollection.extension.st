Extension { #name : #OrderedCollection }

{ #category : #'*SmallAmp' }
OrderedCollection >> collect: aBlock displayingProgress: aStringOrBlock [
	| newCollection |
	newCollection := self species new.
	self do: [ :each | newCollection add: (aBlock value: each) ] displayingProgress: aStringOrBlock.
	^ newCollection
]

{ #category : #'*SmallAmp' }
OrderedCollection >> smallAmpAcceptSerializerVisitor: aVisitor atDepth: anInteger [
	^ aVisitor visitCollection: self atDepth: anInteger
]
