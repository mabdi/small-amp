as yet unclassified
replaceMappings: map on: aMethod
	| result |
	result := OrderedCollection new.
	map value
		do: [ :change | 
			| rewriter mClone theCode |
			mClone := aMethod copy.
			rewriter := RBParseTreeRewriter new.
			rewriter replaceTree: map key withTree: change.
			rewriter executeTree: mClone.
			theCode := mClone formattedCode.
			(theCode includesSubstring: '<an unprintable nonliteral value>') ifTrue: [self halt].
			result add: theCode ].
	^ result