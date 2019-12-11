Class {
	#name : #SAAbstractInputAmplifier,
	#superclass : #Object,
	#category : #'Amplification-Core'
}

{ #category : #removing }
SAAbstractInputAmplifier >> mutate: aMethod [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SAAbstractInputAmplifier >> renameMutations: mutations [
	| idx |
	idx := 0.
	^ mutations
		collect: [ :mtd | 

			idx := idx + 1.
			(ASTHelper new
				renameMethodName: mtd
				append: '_' , idx asString) formattedCode ]
]
