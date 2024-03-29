Extension { #name : #TestCase }

{ #category : #'*SmallAmp' }
TestCase class >> smallAmpAmplifiedMethods [
	^ self methods
		select: [ :z | z hasPragmaNamed: SAGenericMethods new defaultPragma ]
]

{ #category : #'*SmallAmp' }
TestCase class >> smallAmpOriginalTestCase [
	^ self
]

{ #category : #'*SmallAmp' }
TestCase class >> smallAmpTargetClasses [
	| c t |
	self isAbstract
		ifTrue: [ ^ nil ].
	(self name includesSubstring: 'Test') ifFalse: [^ nil].	
	c := (self name copyUpToSubstring: 'Test') .	
	(SmalltalkImage current hasClassNamed: c)
		ifTrue: [ t := SmalltalkImage current classNamed: c ]
		ifFalse: [ ^ nil ].
	(t methods anySatisfy: #isAbstract)
		ifTrue: [ ^ nil ].
	^ {t}
]

{ #category : #'*SmallAmp' }
TestCase class >> smallAmpTestsToIgnore [
	| result failedSelector |
result := self suite run.
			failedSelector := (result failures
				, result expectedDefects
				collect: [ :failed | failed class lookupSelector: failed selector ])
				asOrderedCollection.
			^ failedSelector 
]
