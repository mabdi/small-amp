Extension { #name : #TestCase }

{ #category : #'*SmallAmp-DrTests' }
TestCase class >> smallAmpTargetClasses [
	| c t |
	c := self name allButLast: 'Test' size.
	(SmalltalkImage current hasClassNamed: c)
		ifTrue: [ t := SmalltalkImage current classNamed: c ]
		ifFalse: [ ^ nil ].
	(t methods anySatisfy: #isAbstract)
		ifTrue: [ ^ nil ].
	^ {t}
]
