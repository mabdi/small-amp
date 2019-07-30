initialization
topContext: aContext
	| context |
	context := aContext.
	[ context receiver isNotNil
		and: [ (context receiver isKindOf: insideObject) not ] ]
		whileTrue: [ context := context sender ].
	"[ (context receiver isKindOf: self class)
		or: [ (context receiver isKindOf: BlockClosure)
				and: [ context receiver outerContext receiver isKindOf: self class ] ] ]
		whileTrue: [ context := context sender ]."
	context receiver ifNotNil: [ ^ context ].
	^ nil