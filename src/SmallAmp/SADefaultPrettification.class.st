Class {
	#name : #SADefaultPrettification,
	#superclass : #SAAbstractPrettification,
	#instVars : [
		'links',
		'usedNames'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #initialization }
SADefaultPrettification >> initialize [
	usedNames := Dictionary new
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> prettify [
	self flag: #TODO.	"pack statements"
		self renameTempVariables
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> renameInsideMethod: aMethodSrc profiles: varTypes [
	| src newName ast |
	src := SAASTHelper new cleanUp: aMethodSrc.
	ast := SAASTHelper new parsedMethodFrom: src.
	newName := ast temporaries
		select: [ :tv | tv name matchesRegex: SAASTHelper tempPattern ]
		thenCollect: [ :t | 
			t name
				-> (varTypes at: ast selector , ':' , t name) canonicalArgumentName ].
	^ self renameTemp: newName in: ast
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> renameTemp: nameMapping in: mtdAST [
	| rewriter |
	self flag: #todo.	"use integer index"
	nameMapping
		withIndexDo: [ :kvp :idx | 
			nameMapping
				withIndexDo: [ :kvp2 :idx2 | 
					idx < idx2
						ifTrue: [ kvp value = kvp2 value
								ifTrue: [ kvp2 value: kvp2 value , '0' ] ] ] ].
	rewriter := RBParseTreeRewriter new.
	nameMapping do: [ :mp | rewriter replace: mp key with: mp value ].
	rewriter executeTree: mtdAST.
	nameMapping
		do: [ :kvp | 
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
