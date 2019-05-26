removing
convertAllToAssert: aParseTree transformers: collTransformers
	| rewriter parser |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	collTransformers
		do: [ :each | 
			each findPattern
				do: [ :ptrn | rewriter replace: ptrn with: each changeToAssertPattern ]].
	rewriter executeTree: parser.
	^ rewriter tree