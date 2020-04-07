Class {
	#name : #SADefaultSimplification,
	#superclass : #SAAbstractSimplification,
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SADefaultSimplification >> applyMessageRemove: index on: aMethod [
	| empty theCode |
	(self isAssertion: (aMethod statements at: index))
		ifTrue: [ ^ nil ].
	empty := RBParser parseExpression: ''.
	aMethod statements at: index put: empty.
	theCode := aMethod formattedCode.
	(theCode includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ self error: 'sth is wrong. you shouldnt be here!' ].
	^ theCode
]

{ #category : #removing }
SADefaultSimplification >> isAssertion: aNode [
	| mtd |
	aNode isMessage
		ifFalse: [ ^ false ].
	aNode receiver isSelf
		ifFalse: [ ^ false ].
	mtd := TestAsserter methodDict
		at: aNode selector
		ifAbsent: [ ^ false ].
	^ mtd smallAmpIsAssertion 
]

{ #category : #'as yet unclassified' }
SADefaultSimplification >> simplify [
	[| newBody |
	theClass methods
		select: [ :m | m hasPragmaNamed: SAASTHelper defaultPragma ]
		thenDo: [ :m | 
			newBody := self simplifyMethod: m ast.
			theClass compile: newBody ]]
]

{ #category : #'as yet unclassified' }
SADefaultSimplification >> simplifyMethod: mtdAST [
	| newBodies |
	newBodies := OrderedCollection new.
	mtdAST statements
		doWithIndex:
			[ :statement :index | newBodies add: (self applyMessageRemove: index on: mtdAST) ]
]
