"
A SADefaultPrettificationTest is a test class for testing the behavior of SADefaultPrettification
"
Class {
	#name : #SADefaultPrettificationTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Core'
}

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
