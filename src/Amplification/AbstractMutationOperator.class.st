Class {
	#name : #AbstractMutationOperator,
	#superclass : #Object,
	#category : #'Amplification-Core'
}

{ #category : #removing }
AbstractMutationOperator >> mutate: aMethod [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
AbstractMutationOperator >> renameMutations: mutations [
	| idx |
	idx := 0.
	^ mutations
		collect: [ :mtd | 

			idx := idx + 1.
			(ASTHelper uniqueInstance
				renameMethodName: mtd
				append: '_' , idx asString) formattedCode ]
]
