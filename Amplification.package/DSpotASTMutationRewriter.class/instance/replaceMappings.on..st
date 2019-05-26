as yet unclassified
replaceMappings: map on: aMethod
	| result |
	result := OrderedCollection new.
	map value
		do: [ :change | 
			| rewriter mClone |
			mClone := aMethod copy.
			rewriter := RBParseTreeRewriter new.
			rewriter replaceTree: map key withTree: change.
			rewriter executeTree: mClone.
			result add: mClone formattedCode ].
	^ result