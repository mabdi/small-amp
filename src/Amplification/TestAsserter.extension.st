Extension { #name : #TestAsserter }

{ #category : #'*Amplification' }
TestAsserter >> assert: actual equals: expected description: description [ 
	^ self
		assert: actual = expected
		description: description
]

{ #category : #'*Amplification' }
TestAsserter >> deny: actual equals: expected description: description [ 
	^ self
		deny: actual = expected
		description: description
]

{ #category : #'*Amplification' }
TestAsserter >> should: aBlock notTakeMoreThan: aDuration description: description [ 
	^ aBlock
		valueWithin: aDuration
		onTimeout: [ self
				assert: false
				description: description ]
]
