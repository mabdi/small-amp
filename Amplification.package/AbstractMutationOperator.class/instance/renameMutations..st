as yet unclassified
renameMutations: mutations
	| idx |
	idx := 0.
	^ mutations
		collect: [ :mtd | 

			idx := idx + 1.
			(ASTHelper uniqueInstance
				renameMethodName: mtd
				append: '_' , idx asString) formattedCode ]