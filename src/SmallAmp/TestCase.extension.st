Extension { #name : #TestCase }

{ #category : #'*SmallAmp' }
TestCase class >> smallAmpAmplifiedMethods [
	^ self methods
		select: [ :z | z hasPragmaNamed: SAASTHelper new defaultPragma ]
]

{ #category : #'*SmallAmp' }
TestCase class >> smallAmpAssertionDensity [
	| methods |
	methods := self methods select: #isTestMethod.
	^ ((methods
		collect: [ :m | SATestAssertionDensity new densityForMethod: m ])
		inject: 0
		into: [ :s :i | s + i ]) / methods size printShowingDecimalPlaces: 2
]

{ #category : #'*SmallAmp' }
TestCase class >> smallAmpTargetClasses [
	| c t |
	self isAbstract
		ifTrue: [ ^ nil ].
	(self name endsWith: 'Test') ifFalse: [^ nil].	
	c := self name allButLast: 'Test' size.
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
