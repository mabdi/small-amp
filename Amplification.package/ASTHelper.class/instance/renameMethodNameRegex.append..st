as yet unclassified
renameMethodNameRegex: aSourceCode append: aText
	| mName |
	mName := self extractMethodNameRegex: aSourceCode.
	^ mName , aText
		, (aSourceCode copyFrom: mName size + 1 to: aSourceCode size)