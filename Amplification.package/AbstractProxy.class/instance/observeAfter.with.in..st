initialization
observeAfter: aSelector with: anArray in: aReceiver
	self subclassResponsibility 
	"| id ctx lastctx |
	ctx := thisContext sender.
	lastctx := thisContext.
	[ ctx receiver class = MethodCallProxy ]
		whileTrue: [ lastctx := ctx.
			ctx := ctx sender ].
	id := ctx pc.
	self halt"

	"observer observe: anObject name: '' id: id"

	