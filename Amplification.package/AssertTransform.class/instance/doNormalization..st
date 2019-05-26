mutant generation
doNormalization: aParseTree
	| rewriter parser |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	rewriter replace: self findPattern with: self changeToAssertPattern.
	rewriter executeTree: parser.
	^ rewriter tree