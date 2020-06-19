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
SADefaultPrettification >> prettify [
	self flag: #TODO.	"pack statements"
		self renameTempVariables
]

{ #category : #'as yet unclassified' }
SADefaultPrettification >> renameInsideMethod: aMethodSrc profiles: varTypes [
	| src newNames ast |
	src := SAASTHelper new cleanUp: aMethodSrc.
	ast := SAASTHelper new parsedMethodFrom: src.
	newNames := (ast temporaries
		select: [ :tv | tv name matchesRegex: SAASTHelper tempPattern ]
		thenCollect: [ :t | 
			t name
				-> (varTypes at: ast selector , ':' , t name) canonicalArgumentName ])
		.
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
