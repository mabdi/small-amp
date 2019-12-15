"
A SAObserverInsertingRewriterTest is a test class for testing the behavior of SAObserverInsertingRewriter
"
Class {
	#name : #SAObserverInsertingRewriterTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #accessing }
SAObserverInsertingRewriterTest >> astHelper [
	^ SAASTHelper new
]

{ #category : #tests }
SAObserverInsertingRewriterTest >> testAMessageAndACascadeAndInstvar [
	" Observer Inserter will not break a cascade to multiple message calls. You should use a Normalizer "

	| methodAST sourceCode expectingCode expectingAST |
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
			                        valueWithin: 999 milliSeconds
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
			on: Exception
			do: [ self halt ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 1 ].
	[ 
	| smallamp_elapsedTime noObserve |
	noObserve := false.
	smallamp_elapsedTime := Time millisecondsToRun: [ 
		                        [ 
		                        tmp1 := Array
			                                with: 1;
			                                with: 2 ]
			                        valueWithin: 999 milliSeconds
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
			on: Exception
			do: [ self halt ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 2 ]'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	SAObserverInsertingRewriter runWith: methodAST.
	self assert: methodAST dump equals: expectingAST dump
]

{ #category : #tests }
SAObserverInsertingRewriterTest >> testAMessageAndACascadeTwoTemps [
	" Observer Inserter will not break a cascade to multiple message calls. You should use a Normalizer "

	| methodAST sourceCode expectingCode expectingAST |
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
			                        valueWithin: 999 milliSeconds
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
			on: Exception
			do: [ self halt ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 1 ].
	[ 
	| smallamp_elapsedTime noObserve |
	noObserve := false.
	smallamp_elapsedTime := Time millisecondsToRun: [ 
		                        [ 
		                        tmp2 := Array
			                                with: 1;
			                                with: 2 ]
			                        valueWithin: 999 milliSeconds
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
			on: Exception
			do: [ self halt ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 2 ]'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	SAObserverInsertingRewriter runWith: methodAST.
	self assert: methodAST dump equals: expectingAST dump
]

{ #category : #tests }
SAObserverInsertingRewriterTest >> testNoMessageCall [
	| methodAST sourceCode expectingCode expectingAST |
	sourceCode := 'foo
	a := 1'.
	expectingCode := 'foo
	a := 1'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	SAObserverInsertingRewriter runWith: methodAST.
	self assert: methodAST dump equals: expectingAST dump
]

{ #category : #tests }
SAObserverInsertingRewriterTest >> testWithCascade [
	" Observer Inserter will not break a cascade to multiple message calls. You should use a Normalizer "
	| methodAST sourceCode expectingCode expectingAST |
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
			                        valueWithin: 999 milliSeconds
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
			on: Exception
			do: [ self halt ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 2 ]'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	SAObserverInsertingRewriter runWith: methodAST.
	self assert: methodAST dump equals: expectingAST dump
]

{ #category : #tests }
SAObserverInsertingRewriterTest >> testWithMessageCall [
	| methodAST sourceCode expectingCode expectingAST |
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
			                        valueWithin: 999 milliSeconds
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
			on: Exception
			do: [ self halt ] ] ]
		on: Error
		do: [ :ex | self class observer observeException: ex id: 2 ]'.
	methodAST := self astHelper parsedMethodFrom: sourceCode.
	expectingAST := self astHelper parsedMethodFrom: expectingCode.
	SAObserverInsertingRewriter runWith: methodAST.
	self assert: methodAST dump equals: expectingAST dump
]
