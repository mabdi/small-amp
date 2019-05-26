as yet unclassified
buildAxularyClass: aMethod basedOn: aClass
	| generatedClass |
	generatedClass := ASTHelper uniqueInstance
		buildAnTestClassWith: {}
		using: aClass.
	generatedClass class addInstVarNamed: 'observer'.
	generatedClass class
		compile: 'observer ^ observer ifNil: [ observer := Observer new ]'.
	generatedClass
		compile:
			'observe: anObj name: aString id:anInt 
			       ^ self class observer observe: anObj name: aString id: anInt'.
	generatedClass compile: aMethod formattedCode.
	^ generatedClass