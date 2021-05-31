"
A SADefaultPrettificationTest is a test class for testing the behavior of SADefaultPrettification
"
Class {
	#name : #SADefaultPrettificationTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethod [
	| method ins src2 ast |
	"no change"
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := t3 method2.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := t3 method2.
	
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodCascade [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := ins method2.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t2 := ins method1; method2.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodCascade2 [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := ins method2.
	t3 := ins2 method2.
	t3 := t1 method2.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := ins method2.
	t3 := ins2 method2.
	t3 := t1 method2.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodCascade3 [
	| method ins src2 ast continue |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := ins method2.
	t3 := ins method3.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	continue := true.
	[ continue ]
		whileTrue: [ continue := ins packStatementsInMethod: ast ].
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t3 := ins method1; method2; method3.
	'
]

{ #category : #tests }
SADefaultPrettificationTest >> testPackStatementsInMethodCascade4 [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins m1;m2.
	t2 := ins m3.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t2 := ins m1; m2; m3.
	'
]

{ #category : #tests }
SADefaultPrettificationTest >> testPackStatementsInMethodCascade5 [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins m1.
	t2 := ins m2; m3.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t2 := ins m1; m2; m3.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodCascade6 [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins m1; m2; m3.
	t2 := ins m4; m5.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t2 := ins m1; m2; m3; m4; m5
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodCascade7 [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins m1 m2 m3.
	t2 := ins m4 m5.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
		t1 := ins m1 m2 m3.
	t2 := ins m4 m5.

	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodCascade8 [
	| method ins src2 ast continue |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	ins method1.
	ins method2.
	ins method3.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	continue := true.
	[ continue ]
		whileTrue: [ continue := ins packStatementsInMethod: ast ].
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	ins method1; method2; method3.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodChain [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := t1 method2.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t2 := ins method1 method2.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodChain2 [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := t1 method2.
	t3 := ins2 method2.
	t3 := t1 method2.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := t1 method2.
	t3 := ins2 method2.
	t3 := t1 method2.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodChain3 [
	| method ins src2 ast continue |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := t1 method2.
	t3 := t2 method3.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	continue := true.
	[ continue ] whileTrue: 
	[continue := ins packStatementsInMethod: ast].
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t3 := ins method1 method2 method3.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodChain4 [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := 1 + 1.
	t2 := t1 method2.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t2 := (1 + 1) method2.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodChain5 [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := 1.
	t2 := t1 method2.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t2 := 1 method2.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodChain6 [
	| method ins src2 ast |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins m1 m2 m3.
	t2 := t1 m4.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	src2 := ins packStatementsInMethod: ast.
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t2 := ins m1 m2 m3 m4
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testPackStatementsInMethodChain7 [
	| method ins src2 ast continue |
	ins := SADefaultPrettification new.
	method := 'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	t1 := ins method1.
	t2 := t1 method2.
	t2 method3.
	'.
	ast := SAGenericMethods new parsedMethodFrom: method.
	continue := true.
	[ continue ]
		whileTrue: [ continue := ins packStatementsInMethod: ast ].
	self
		assertMethodSourceCode: ast formattedCode
		equals:
			'testSomeThing
	<madeBySmallAmp>
	| t1 t2 t3 |
	ins method1 method2 method3.
	'
]

{ #category : #test }
SADefaultPrettificationTest >> testRename [
	| method ins varTypes src2 |
	ins := SADefaultPrettification new.
	method := 'testCache04_amp_A3
	<madeBySmallAmp>
	| es tmp_J8BZ5sN37d1 |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	tmp_J8BZ5sN37d1 := es height.
	self assert: tmp_J8BZ5sN37d1 equals: 0.0'.
	varTypes := {('testCache04_amp_A3:tmp_ZvcxqDN0V31'
		-> OrderedCollection).
	('testCache04_amp_A3:tmp_J8BZ5sN37d1' -> Number)} asDictionary.
	src2 := ins renameInsideMethod: method profiles: varTypes.
	self
		assertMethodSourceCode: src2
		equals:
			'testCache04_amp_A3
	<madeBySmallAmp>
	| es aNumber |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	aNumber := es height.
	self assert: aNumber equals: 0.0'
]

{ #category : #tests }
SADefaultPrettificationTest >> testRenameDuplicate [
	| method ins varTypes src2 |
	ins := SADefaultPrettification new.
	method := 'testCache04_amp_A3
	<madeBySmallAmp>
	| es tmp_J8BZ5sN37d1 tmp_J8BZ5sN37z2 |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	tmp_J8BZ5sN37d1 := es height.
	self assert: tmp_J8BZ5sN37d1 equals: 0.0.
	tmp_J8BZ5sN37z2 := es width.
	self assert: tmp_J8BZ5sN37z2 equals: 1.0.
	'.
	varTypes := {('testCache04_amp_A3:tmp_ZvcxqDN0V31'
		-> OrderedCollection).
	('testCache04_amp_A3:tmp_J8BZ5sN37d1' -> Number).
	('testCache04_amp_A3:tmp_J8BZ5sN37z2' -> Number)} asDictionary.
	src2 := ins renameInsideMethod: method profiles: varTypes.
	self
		assertMethodSourceCode: src2
		equals:
			'testCache04_amp_A3
	<madeBySmallAmp>
	| es aNumber1 aNumber2 |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	aNumber1 := es height.
	self assert: aNumber1 equals: 0.0.
	aNumber2 := es width.
	self assert: aNumber2 equals: 1.0'
]

{ #category : #tests }
SADefaultPrettificationTest >> testRenameDuplicateIncrease [
	| method ins varTypes src2 |
	ins := SADefaultPrettification new.
	method := 'testCache04_amp_A3
	<madeBySmallAmp>
	| es tmp_J8BZ5sN37d1 tmp_J8BZ5sN37z2 tmp_J8BZ5sN37z3 |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	tmp_J8BZ5sN37d1 := es height.
	self assert: tmp_J8BZ5sN37d1 equals: 0.0.
	tmp_J8BZ5sN37z2 := es width.
	self assert: tmp_J8BZ5sN37z2 equals: 1.0.
	tmp_J8BZ5sN37z3 := es width.
	self assert: tmp_J8BZ5sN37z3 equals: 1.0.
	'.
	varTypes := {('testCache04_amp_A3:tmp_ZvcxqDN0V31'
		-> OrderedCollection).
	('testCache04_amp_A3:tmp_J8BZ5sN37d1' -> Number).
	('testCache04_amp_A3:tmp_J8BZ5sN37z2' -> Number).
	('testCache04_amp_A3:tmp_J8BZ5sN37z3' -> Number)} asDictionary.
	src2 := ins renameInsideMethod: method profiles: varTypes.
	self
		assertMethodSourceCode: src2
		equals:
			'testCache04_amp_A3
	<madeBySmallAmp>
	| es aNumber1 aNumber2 aNumber3 |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	aNumber1 := es height.
	self assert: aNumber1 equals: 0.0.
	aNumber2 := es width.
	self assert: aNumber2 equals: 1.0.
	aNumber3 := es width.
	self assert: aNumber3 equals: 1.0'
]

{ #category : #tests }
SADefaultPrettificationTest >> testRenameDuplicateIncreaseUnused [
	| method ins varTypes src2 |
	ins := SADefaultPrettification new.
	method := 'testCache04_amp_A3
	<madeBySmallAmp>
	| es tmp_J8BZ5sN37d1 tmp_J8BZ5sN37z2 tmp_J8BZ5sN37z3 |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	tmp_J8BZ5sN37d1 := es height.
	self assert: tmp_J8BZ5sN37d1 equals: 0.0.
	tmp_J8BZ5sN37z2 := es width.
	tmp_J8BZ5sN37z3 := es width.
	self assert: tmp_J8BZ5sN37z3 equals: 1.0.
	'.
	varTypes := {('testCache04_amp_A3:tmp_ZvcxqDN0V31'
		-> OrderedCollection).
	('testCache04_amp_A3:tmp_J8BZ5sN37d1' -> Number).
	('testCache04_amp_A3:tmp_J8BZ5sN37z2' -> Number).
	('testCache04_amp_A3:tmp_J8BZ5sN37z3' -> Number)} asDictionary.
	src2 := ins renameInsideMethod: method profiles: varTypes.
	self
		assertMethodSourceCode: src2
		equals:
			'testCache04_amp_A3
	<madeBySmallAmp>
	| es aNumber1 aNumber2 |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	aNumber1 := es height.
	self assert: aNumber1 equals: 0.0.
	es width.
	aNumber2 := es width.
	self assert: aNumber2 equals: 1.0'
]

{ #category : #test }
SADefaultPrettificationTest >> testRenameWithCleanUp [
	| method ins varTypes src2 |
	ins := SADefaultPrettification new.
	method := 'testCache04_amp_A3
	<madeBySmallAmp>
	| es tmp_ZvcxqDN0V31 tmp_J8BZ5sN37d1 |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	tmp_ZvcxqDN0V31 := es
		addAll:
			(#(1)
				collect: [ :n | 
					RSBox new
						model: n;
						yourself ]
				as: RSGroup).
	tmp_J8BZ5sN37d1 := es height.
	self assert: tmp_J8BZ5sN37d1 equals: 0.0'.
	varTypes := {('testCache04_amp_A3:tmp_ZvcxqDN0V31'
		-> OrderedCollection).
	('testCache04_amp_A3:tmp_J8BZ5sN37d1' -> Number)} asDictionary.
	src2 := ins renameInsideMethod: method profiles: varTypes.
	self
		assertMethodSourceCode: src2
		equals:
			'testCache04_amp_A3
	<madeBySmallAmp>
	| es aNumber |
	es := #(1)
		collect: [ :n | 
			RSBox new
				model: n;
				yourself ]
		as: RSGroup.
	es
		addAll:
			(#(1)
				collect: [ :n | 
					RSBox new
						model: n;
						yourself ]
				as: RSGroup).
	aNumber := es height.
	self assert: aNumber equals: 0.0'
]
