removing
removeAssertionsNoExtract: aParseTree transformers: collTransformers
	| rewriter parser empty|
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	empty:= RBParser parseExpression: ''.
	collTransformers
		do: [ :each | 
			each findPattern
				do: [ :ptrn | 
					rewriter addRule: (RBBlockReplaceRule searchFor: ptrn replaceWith: [:node | empty ]) ] ].
	rewriter executeTree: parser.
	^ rewriter tree