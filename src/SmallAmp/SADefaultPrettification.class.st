Class {
	#name : #SADefaultPrettification,
	#superclass : #SAAbstractPrettification,
	#instVars : [
		'links',
		'usedNames'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADefaultPrettification >> applyTransformCascadeIn: anAST index: anIndex [
	| r1 r2 |
	r1 := (anAST statements at: anIndex) isAssignment 
		ifTrue: [ (anAST statements at: anIndex) value ]
		ifFalse: [ anAST statements at: anIndex ].
	r2 := (anAST statements at: anIndex + 1) isAssignment
		ifTrue: [ (anAST statements at: anIndex + 1) value ]
		ifFalse: [ anAST statements at: anIndex + 1 ].
	r1 isCascade
		ifFalse:
			[ r1 parent replaceNode: r1 withNode: (RBCascadeNode messages: {r1}) ].
	r2 isCascade
		ifFalse: [ r2 parent
				replaceNode: r2
				withNode: (RBCascadeNode messages: {r2} asOrderedCollection) ].
	r1 := (anAST statements at: anIndex) isAssignment
		ifTrue: [ (anAST statements at: anIndex) value ]
		ifFalse: [ anAST statements at: anIndex ].
	r2 := (anAST statements at: anIndex + 1) isAssignment
		ifTrue: [ (anAST statements at: anIndex + 1) value ]
		ifFalse: [ anAST statements at: anIndex + 1 ].
	r1 messages reverseDo: [ :msg | r2 messages addFirst: msg ].
	anAST statements removeAt: anIndex
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> applyTransformChainIn: anAST index: anIndex [
	| m2 |
	m2 := (anAST statements at: anIndex + 1) isAssignment
		ifTrue: [ (anAST statements at: anIndex + 1) value  ]
		ifFalse: [ (anAST statements at: anIndex + 1)  ].
	m2
		replaceNode: m2 receiver
		withNode: (anAST statements at: anIndex) value.
	anAST statements removeAt: anIndex
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> fixNamePostfixes: nameMapping [
	| needsPostfix names idx |
	names := (nameMapping collect: #value) asSet.
	names
		do: [ :name | 
			needsPostfix := nameMapping select: [ :x | x value = name ].
			needsPostfix size > 1
				ifTrue: [ idx := 1.
					needsPostfix
						do: [ :kvp | kvp value: kvp value , idx asString. idx:= idx + 1 ] ] ]
]

{ #category : #initialization }
SADefaultPrettification >> initialize [
	usedNames := Dictionary new
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> isCascadePatternInAST: ast index: i [
	| s1 s2 r1 r2 |
	s1 := ast statements at: i.
	s2 := ast statements at: i + 1.
	s1 isAssignment | s1 isMessage | s1 isCascade
		ifFalse: [ ^ false ].
	s2 isAssignment | s2 isMessage | s2 isCascade
		ifFalse: [ ^ false ].
	(s1 isAssignment not or: [ s1 value isMessage | s1 value isCascade ])
		ifFalse: [ ^ false ].
	(s2 isAssignment not or: [ s2 value isMessage | s2 value isCascade ])
		ifFalse: [ ^ false ].
	r1 := s1 isAssignment ifTrue: [ s1 value receiver ] ifFalse: [ s1 receiver ].
	r2 := s2 isAssignment ifTrue: [ s2 value receiver ] ifFalse: [ s2 receiver ].
	
	r1 = r2
		ifFalse: [ ^ false ].
	s1 isAssignment
		ifTrue: [ i + 2 to: ast statements size do: [ :s | 
				(((ast statements at: s) allVariables select: #isRead)
					anySatisfy: [ :v | v = s1 variable ])
					ifTrue: [ ^ false ] ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> isChainPatternInAST: ast index: i [
	| s1 s2 r2 |
	s1 := ast statements at: i.
	s2 := ast statements at: i + 1.
	s1 isAssignment
		ifFalse: [ ^ false ].
	s2 isAssignment | s2 isMessage
		ifFalse: [ ^ false ].
	(s2 isAssignment not or: [ s2 value isMessage ])
		ifFalse: [ ^ false ].
	r2 := s2 isAssignment
		ifTrue: [ s2 value receiver ]
		ifFalse: [ s2 receiver ].
	s1 variable = r2
		ifFalse: [ ^ false ].
	i + 2 to: ast statements size do: [ :s | 
		(((ast statements at: s) allVariables select: #isRead)
			anySatisfy: [ :v | v = s1 variable ])
			ifTrue: [ ^ false ] ].
	^ true
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> packStatements [
	| newBody continue tree |
	theClass methods
		select: [ :m | m hasPragmaNamed: SAASTHelper defaultPragma ]
		thenDo: [ :m | 
			continue := true.
			tree := m ast copy.
			[ continue ] whileTrue: [ continue := self packStatementsInMethod: tree ].
			newBody := tree formattedCode.
			theClass compile: newBody ]
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> packStatementsInMethod: aMethodAST [
	1 to: aMethodAST statements size - 1 do: [ :i | 
		(self isChainPatternInAST: aMethodAST index: i)
			ifTrue: [ self applyTransformChainIn: aMethodAST index: i.
				^ true ].
		(self isCascadePatternInAST: aMethodAST index: i)
			ifTrue: [ self applyTransformCascadeIn: aMethodAST index: i.
				^ true ] ].
	^ false
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> prettify [
	self packStatements.
	self renameTempVariables
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> renameInsideMethod: aMethodSrc profiles: varTypes [
	| src newNames ast |
	src := SAASTHelper new cleanUp: aMethodSrc.
	ast := SAASTHelper new parsedMethodFrom: src.
	newNames := ast temporaries
		select: [ :tv | tv name matchesRegex: SAASTHelper tempPattern ]
		thenCollect: [ :t | 
			t name
				-> (varTypes at: ast selector , ':' , t name ifAbsent: [nil class]) canonicalArgumentName ].
	^ self renameTemp: newNames in: ast
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> renameTemp: nameMapping in: mtdAST [
	| rewriter |
	self fixNamePostfixes: nameMapping.
	
	rewriter := RBParseTreeRewriter new.
	nameMapping associationsDo: [ :mp | rewriter replace: mp key with: mp value ].
	rewriter executeTree: mtdAST.
	nameMapping
		associationsDo: [ :kvp | 
			(mtdAST temporaries select: [ :tm | tm name = kvp key ]) first
				name: kvp value ].
	^ mtdAST formattedCode
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> renameTempVariables [
	| varTypes newBody |
	varTypes := (SAVariableTypeProfiler initializeWith: config)
		testMethods: (theClass methods collect: #sourceCode);
		testClass: theClass;
		run;
		variablesTypes.
	theClass methods
		select: [ :m | m hasPragmaNamed: SAASTHelper defaultPragma ]
		thenDo: [ :m | newBody := self renameInsideMethod: m sourceCode profiles: varTypes.theClass compile: newBody ]
]
