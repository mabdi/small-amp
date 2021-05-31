"
A SADefaultAssertionAmplifierTest is a test class for testing the behavior of SADefaultAssertionAmplifier
"
Class {
	#name : #SADefaultAssertionAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'aConfig',
		'ins'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #accessing }
SADefaultAssertionAmplifierTest >> astHelper [
	^ SAGenericMethods new
]

{ #category : #running }
SADefaultAssertionAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	aConfig := SAConfig default statementTimeOut: 1000;
		yourself.
	ins := SADefaultAssertionAmplifier initializeWith: aConfig.
	ins testRunTimeoutMillis: 1000
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testAMessageAndACascadeAndInstvar [
	" Observer Inserter will not break a cascade to multiple message calls. You should use a Normalizer "

	| methodAST sourceCode expectingCode expectingAST amplifier |
	sourceCode := 'foo
	| tmp1 |
	a := foo bar.
	tmp1 := Array
		with: 1;
		with: 2'.
	expectingCode := 'foo
	| tmp1 |
	[ 
	| smallamp_elapsedTime noObserve |
	noObserve := false.
	smallamp_elapsedTime := Time millisecondsToRun: [ 
		                        [ a := foo bar ]
			                        valueWithin: 1000 milliSeconds
			                        onTimeout: [ 
				                        self class observer
					                        observeTimeOut: 1000
					                        id: 1.
				                        noObserve := true ] ].
	noObserve ifFalse: [ 
		[ 
		self class observer observe: foo name: ''foo'' id: 1.
		self class observer
			observeResult: a
			receiver: foo
			selector: #bar
			name: #a
			id: 1 ]
			on: Error
			do: [ :saERR| self error: ''checkMe'' ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 1.
			^ self ].
	[ 
	| smallamp_elapsedTime noObserve |
	noObserve := false.
	smallamp_elapsedTime := Time millisecondsToRun: [ 
		                        [ 
		                        tmp1 := Array
			                                with: 1;
			                                with: 2 ]
			                        valueWithin: 1000 milliSeconds
			                        onTimeout: [ 
				                        self class observer
					                        observeTimeOut: 1000
					                        id: 2.
				                        noObserve := true ] ].
	noObserve ifFalse: [ 
		[ 
		self class observer observe: Array name: ''Array'' id: 2.
		self class observer
			observeResult: tmp1
			receiver: Array
			selector: #with:
			name: #tmp1
			id: 2 ]
			on: Error
			do: [ :saERR | self error: ''checkMe'' ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 2.
			^ self ]'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	amplifier := (SADefaultAssertionAmplifier initializeWith: aConfig)
		insertObservers: methodAST.
	self
		assertMethodSourceCode: methodAST formattedCode
		equals: expectingCode
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testAMessageAndACascadeTwoTemps [
	" Observer Inserter will not break a cascade to multiple message calls. You should use a Normalizer "

	| methodAST sourceCode expectingCode expectingAST amplifier |
	sourceCode := 'foo
	| tmp1 tmp2 |
	tmp1 := foo bar.
	tmp2 := Array
		with: 1;
		with: 2'.
	expectingCode := 'foo
	| tmp1 tmp2 |
	[ 
	| smallamp_elapsedTime noObserve |
	noObserve := false.
	smallamp_elapsedTime := Time millisecondsToRun: [ 
		                        [ tmp1 := foo bar ]
			                        valueWithin: 1000 milliSeconds
			                        onTimeout: [ 
				                        self class observer
					                        observeTimeOut: 1000
					                        id: 1.
				                        noObserve := true ] ].
	noObserve ifFalse: [ 
		[ 
		self class observer observe: foo name: ''foo'' id: 1.
		self class observer
			observeResult: tmp1
			receiver: foo
			selector: #bar
			name: #tmp1
			id: 1 ]
			on: Error
			do: [ :saERR | self error: ''checkMe'' ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 1.
			^ self ].
	[ 
	| smallamp_elapsedTime noObserve |
	noObserve := false.
	smallamp_elapsedTime := Time millisecondsToRun: [ 
		                        [ 
		                        tmp2 := Array
			                                with: 1;
			                                with: 2 ]
			                        valueWithin: 1000 milliSeconds
			                        onTimeout: [ 
				                        self class observer
					                        observeTimeOut: 1000
					                        id: 2.
				                        noObserve := true ] ].
	noObserve ifFalse: [ 
		[ 
		self class observer observe: Array name: ''Array'' id: 2.
		self class observer
			observeResult: tmp2
			receiver: Array
			selector: #with:
			name: #tmp2
			id: 2 ]
			on: Error
			do: [ :saERR | self error: ''checkMe'' ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 2.
			^ self ]'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	amplifier := (SADefaultAssertionAmplifier initializeWith: aConfig)
		insertObservers: methodAST.
	self assert: methodAST dump equals: expectingAST dump
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testCase1 [
	"step 0 in to:by:"
	| src sourceCodeWithAssertions |
	src := 'foo 10 to: 100 by: 0'.
	sourceCodeWithAssertions := ins
		amplifyAssertionsFor: (self testModelFor: src).
	self assert: sourceCodeWithAssertions isNil
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testCase2 [
	| src sourceCodeWithAssertions testModel |
	src := 'testFoo | x y | x:= SATestObject new. x showError. y:= x field1 * 2'.
	testModel := SATestMethod
		with: src
		class: SmallBankTest
		targets: {SATestObject}.
	sourceCodeWithAssertions := ins amplifyAssertionsFor: testModel.
	self
		deny: (sourceCodeWithAssertions includesSubstring: 'y:= x field1 * 2')
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testModelFor: src [
	^ SATestMethod with: src class: SmallBankTest targets: {SmallBank}
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testNoMessageCall [
	| methodAST sourceCode expectingCode expectingAST amplifier |
	sourceCode := 'foo
	a := 1'.
	expectingCode := 'foo
	a := 1'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	amplifier := (SADefaultAssertionAmplifier initializeWith: aConfig)
		insertObservers: methodAST.
	self assert: methodAST dump equals: expectingAST dump
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testWithCascade [
	" Observer Inserter will not break a cascade to multiple message calls. You should use a Normalizer "

	| methodAST sourceCode expectingCode expectingAST amplifier |
	sourceCode := 'foo
	| tmp1 |
	a := 1.
	tmp1 := Array
		with: 1;
		with: 2'.
	expectingCode := 'foo
	| tmp1 |
	a := 1.
	[ 
	| smallamp_elapsedTime noObserve |
	noObserve := false.
	smallamp_elapsedTime := Time millisecondsToRun: [ 
		                        [ 
		                        tmp1 := Array
			                                with: 1;
			                                with: 2 ]
			                        valueWithin: 1000 milliSeconds
			                        onTimeout: [ 
				                        self class observer
					                        observeTimeOut: 1000
					                        id: 2.
				                        noObserve := true ] ].
	noObserve ifFalse: [ 
		[ 
		self class observer observe: Array name: ''Array'' id: 2.
		self class observer
			observeResult: tmp1
			receiver: Array
			selector: #with:
			name: #tmp1
			id: 2 ]
			on: Error
			do: [ :saERR | self error: ''checkMe'' ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 2.
			^ self ]'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	amplifier := (SADefaultAssertionAmplifier initializeWith: aConfig)
		insertObservers: methodAST.
	self assert: methodAST dump equals: expectingAST dump
]

{ #category : #tests }
SADefaultAssertionAmplifierTest >> testWithMessageCall [
	| methodAST sourceCode expectingCode expectingAST amplifier |
	sourceCode := 'foo
	| tmp1 |
	a := 1.
	tmp1 := Array with: 1'.
	expectingCode := 'foo
	| tmp1 |
	a := 1.
	[ 
	| smallamp_elapsedTime noObserve |
	noObserve := false.
	smallamp_elapsedTime := Time millisecondsToRun: [ 
		                        [ tmp1 := Array with: 1 ]
			                        valueWithin: 1000 milliSeconds
			                        onTimeout: [ 
				                        self class observer
					                        observeTimeOut: 1000
					                        id: 2.
				                        noObserve := true ] ].
	noObserve ifFalse: [ 
		[ 
		self class observer observe: Array name: ''Array'' id: 2.
		self class observer
			observeResult: tmp1
			receiver: Array
			selector: #with:
			name: #tmp1
			id: 2 ]
			on: Error
			do: [:saERR | self error: ''checkMe'' ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 2.
			^ self ]'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	amplifier := (SADefaultAssertionAmplifier initializeWith: aConfig)
		insertObservers: methodAST.
	self assert: methodAST dump equals: expectingAST dump
]
