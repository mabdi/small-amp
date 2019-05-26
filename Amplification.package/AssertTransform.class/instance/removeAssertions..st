mutant generation
removeAssertions: aParseTree
	| rewriter parser |
	rewriter := RBParseTreeRewriter new.
	parser := aParseTree copy.
	rewriter replace: self findPattern with: self assertPattern.
	rewriter executeTree: parser.
	^ rewriter tree