cleanup
cleanUp: aSourceCode
	| mtd tmps rewriter |
	mtd := RBParser parseMethod: aSourceCode.
	tmps := (mtd body temporaries
		select: [ :tmp | tmp name beginsWith: 'tmp_' ])
		reject: [ :tmp | 
			| visitor |
			visitor := NotUsedTempsVisitor new.
			visitor tmp_var: tmp name.
			mtd acceptVisitor: visitor.
			visitor used ].
	rewriter := RBParseTreeRewriter new.
	tmps do: [ :tmp | rewriter replace: (tmp name,' := ``@x') with: '``@x' ].
	rewriter executeTree: mtd.
	tmps do: [ :tmp | mtd body temporaries remove: tmp].
	^ mtd formattedCode