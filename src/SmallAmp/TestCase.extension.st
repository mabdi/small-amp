Extension { #name : #TestCase }

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