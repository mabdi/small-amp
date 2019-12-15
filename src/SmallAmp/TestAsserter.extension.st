Extension { #name : #TestAsserter }

{ #category : #'*SmallAmp' }
TestAsserter >> assert: actual equals: expected description: description [ 
	^ self
		assert: actual = expected
		description: description
]

{ #category : #'*SmallAmp' }
TestAsserter >> deny: actual equals: expected description: description [ 
	^ self
		deny: actual = expected
		description: description
]

{ #category : #'*SmallAmp' }
TestAsserter >> should: aBlock notTakeMoreThan: aDuration description: description [ 
	^ aBlock
		valueWithin: aDuration
		onTimeout: [ self
				assert: false
				description: description ]
]
