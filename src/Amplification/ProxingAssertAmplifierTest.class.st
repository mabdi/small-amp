Class {
	#name : #ProxingAssertAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'instance'
	],
	#category : #'Amplification-Tests'
}

{ #category : #running }
ProxingAssertAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	instance := ProxyingAssertAmplifier new
]

{ #category : #tests }
ProxingAssertAmplifierTest >> testAssertError [
	| aMethodSrc aClass generatedSource |
	instance targets: {SmallBank2}.
	aMethodSrc := 'testFoo
	| tmp1 tmp2 |
	tmp1 := SmallBank2 new.
	tmp1 deposit: -10'.
	aClass := FakeTestcase.
	generatedSource := instance
		doAssertionAmplification: aMethodSrc
		within: aClass.
	self
		assert: (GeneralHelper renameTempVars: generatedSource)
		equals:
			'testFoo
	| tmp1 tmp2 |
	tmp1 := SmallBank2 new.
	self should: [ tmp1 deposit: -10 ] raise: Error'
]

{ #category : #tests }
ProxingAssertAmplifierTest >> testAssertError1 [
	| aMethodSrc aClass generatedSource |
	instance targets: {SmallBank2}.
	aMethodSrc := 'testFoo
	| tmp1 tmp2 |
	tmp1 := SmallBank2 new.
	tmp2 := tmp1 deposit:-10'.
	aClass := FakeTestcase.
	generatedSource := instance
		doAssertionAmplification: aMethodSrc
		within: aClass.
	self
		assert: (GeneralHelper renameTempVars: generatedSource)
		equals:
			'testFoo
	| tmp1 tmp2 |
	tmp1 := SmallBank2 new.
	self should: [ tmp2 := tmp1 deposit: -10 ] raise: Error'
]

{ #category : #tests }
ProxingAssertAmplifierTest >> testSmallBank1 [
	| aMethodSrc aClass generatedSource |
	instance targets: {SmallBank}.
	aMethodSrc := 'testFoo
	| tmp1 tmp2 |
	
	tmp1 := SmallBank new.
	tmp1 deposit: -10.
	tmp1 withdraw: 10.
	tmp1 deposit: 100'.
	aClass := FakeTestcase.
	generatedSource := instance
		doAssertionAmplification: aMethodSrc
		within: aClass.
	self
		assert: (GeneralHelper renameTempVars: generatedSource)
		equals:
			'testFoo
	| tmp1 tmp2 |
	tmp1 := SmallBank new.
	tmp1 deposit: -10.
	self assert: tmp1 balance equals:  -10.
	tmp1 withdraw: 10.
	self assert: tmp1 balance equals:  -10.
	tmp1 deposit: 100.
	self assert: tmp1 balance equals: 90'
]

{ #category : #tests }
ProxingAssertAmplifierTest >> testSmallBank2 [
	| aMethodSrc aClass generatedSource |
	instance targets: {SmallBank2}.
	aMethodSrc := 'testFoo
	| tmp1 tmp2 |
	tmp1 := SmallBank2 new.
	tmp1 deposit: -10.
	tmp1 withdraw: 10.
	tmp1 deposit: 100'.
	aClass := FakeTestcase.
	generatedSource := instance
		doAssertionAmplification: aMethodSrc
		within: aClass.
	self
		assert: (GeneralHelper renameTempVars: generatedSource)
		equals:
			'testFoo
	| tmp1 tmp2 |
	tmp1 := SmallBank2 new.
	self should: [ tmp1 deposit: -10 ] raise: Error.
	self should: [ tmp1 withdraw: 10 ] raise: Error.
	tmp1 deposit: 100.
	self assert: tmp1 balance equals: 100'
]

{ #category : #tests }
ProxingAssertAmplifierTest >> testWrongTarget [
	| aMethodSrc aClass generatedSource |
	instance targets: {SmallBank2}.
	aMethodSrc := 'testFoo
	| tmp1 tmp2 |
	tmp1 := SmallBank new.
	tmp1 deposit: -10.
	tmp1 withdraw: 10.
	tmp1 deposit: 100'.
	aClass := FakeTestcase.
	generatedSource := instance
		doAssertionAmplification: aMethodSrc
		within: aClass.
	self
		assert: (GeneralHelper renameTempVars: generatedSource)
		equals:
			'testFoo
	| tmp1 tmp2 |
	tmp1 := SmallBank new.
	tmp1 deposit: -10.
	tmp1 withdraw: 10.
	tmp1 deposit: 100'	"We expect No change. because target of testing is SmallBank2"
]
