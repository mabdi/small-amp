"
A SAMethodNormalizingRewriterTest is a test class for testing the behavior of SAMethodNormalizingRewriter
"
Class {
	#name : #SAMethodNormalizingRewriterTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #tests }
SAMethodNormalizingRewriterTest >> astHelper [
	^ SAASTHelper new
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testAssignmentReceiver [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom:
			'testRoomExitCycles
	| model room1 room2 exit1 exit2 ston object |
	(room1 := STONTestMap new) at: #name put: ''Room 1''.
	(room2 := STONTestMap new) at: #name put: ''Room 2''.
	(exit1 := STONTestMap new)
		at: #name put: ''Exit 1'';
		at: #origin put: room1;
		at: #destination put: room2.
	(exit2 := STONTestMap new)
		at: #name put: ''Exit 2'';
		at: #origin put: room2;
		at: #destination put: room1.
	room1 at: #exit put: exit1.
	room2 at: #exit put: exit2.
	model := Array with: room1 with: room2.
	ston := STON toString: model.
	object := STON fromString: ston.'.
	astAfter := self astHelper
		parsedMethodFrom:
			'testRoomExitCycles
	| model room1 room2 exit1 exit2 ston object tmp_QzSdLqXCVx1 tmp_QzSdLqXCVx2 tmp_QzSdLqXCVx3 tmp_QzSdLqXCVx4 tmp_QzSdLqXCVx5 tmp_QzSdLqXCVx6 tmp_QzSdLqXCVx7 tmp_QzSdLqXCVx8 |
	room1 := STONTestMap new.
	tmp_QzSdLqXCVx1 := room1 at: #name put: ''Room 1''.
	room2 := STONTestMap new.
	tmp_QzSdLqXCVx2 := room2 at: #name put: ''Room 2''.
	exit1 := STONTestMap new.
	tmp_QzSdLqXCVx3 := exit1 at: #name put: ''Exit 1''.
	tmp_QzSdLqXCVx4 := exit1	at: #origin put: room1.
	exit1 := exit1	at: #destination put: room2.
	exit2 := STONTestMap new.
	tmp_QzSdLqXCVx5 := exit2	at: #name put: ''Exit 2''.
	tmp_QzSdLqXCVx6 := exit2	at: #origin put: room2.
	exit2 := exit2	at: #destination put: room1.
	tmp_QzSdLqXCVx7 := room1 at: #exit put: exit1.
	tmp_QzSdLqXCVx8 := room2 at: #exit put: exit2.
	model := Array with: room1 with: room2.
	ston := STON toString: model.
	object := STON fromString: ston.'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assertMethodSourceCode: (SAASTHelper new renameTempVars: astBefore formattedCode)
		equals: (SAASTHelper new renameTempVars: astAfter formattedCode)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testAssignmentReceiver2 [
	
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom:
			'assign |x y|
x := (y:=1) + 1.'.
	astAfter := self astHelper
		parsedMethodFrom:
			'assign |x y|
y:=1.
x := y + 1.'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assertMethodSourceCode: (SAASTHelper new renameTempVars: astBefore formattedCode)
		equals: (SAASTHelper new renameTempVars: astAfter formattedCode)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testCascade [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom: 'foo a:=1. Array with:1;with:2'.
	astAfter := 'foo
	| tmp_QzSdLqXCVx1 tmp_QzSdLqXCVx2 |
	a := 1.
	tmp_QzSdLqXCVx2 := Array with: 1.
	tmp_QzSdLqXCVx1 := Array with: 2'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assertMethodSourceCode: (SAASTHelper new renameTempVars: astBefore formattedCode)
		equals: (SAASTHelper new renameTempVars: astAfter)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testCascade2 [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom: 'foo RSChart new
		addPlot: (RSScatterPlot new x: x y: (x raisedTo: 3));
		addPlot: (RSLinePlot new x: x y: (x raisedTo: 2));
		addDecoration: RSHorizontalTick new;
		addDecoration: RSVerticalTick new;
		build'.
	astAfter := 
			'foo
	| tmp_ptzTVYJYPV1 tmp_XxP3938g3N2 tmp_zJnj14bJ4E3 tmp_v3lizTRMDU4 tmp_nwcUHmj7te5 |
	tmp_ptzTVYJYPV1 := RSChart new.
	tmp_XxP3938g3N2 := tmp_ptzTVYJYPV1
		addPlot: (RSScatterPlot new x: x y: (x raisedTo: 3)).
	tmp_zJnj14bJ4E3 := tmp_ptzTVYJYPV1
		addPlot: (RSLinePlot new x: x y: (x raisedTo: 2)).
	tmp_v3lizTRMDU4 := tmp_ptzTVYJYPV1
		addDecoration: RSHorizontalTick new.
	tmp_nwcUHmj7te5 := tmp_ptzTVYJYPV1 addDecoration: RSVerticalTick new.
	tmp_ptzTVYJYPV1 := tmp_ptzTVYJYPV1 build'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assertMethodSourceCode: (SAASTHelper new renameTempVars: astBefore formattedCode)
		equals: (SAASTHelper new renameTempVars: astAfter)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testChain [
	| astBefore astAfter |
	astBefore := self astHelper parsedMethodFrom:
		             'foo a:=1. (Array with:1 with:2) size'.
	astAfter := self astHelper parsedMethodFrom: 'foo
	| tmp_uHdMrJYozl1 tmp_Ihz3cGorrB2 |
	a := 1.
	tmp_Ihz3cGorrB1 := Array with: 1 with: 2.
	tmp_uHdMrJYozl2 := tmp_Ihz3cGorrB1 size'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assert: (SAASTHelper new renameTempVars: astBefore dump)
		equals: (SAASTHelper new renameTempVars: astAfter dump)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testChain3NonArg [
	| astBefore codeAfter |
	astBefore := self astHelper parsedMethodFrom: 'foo a b c. d:= e f g'.
	codeAfter := 'foo
	| tmp_ga4aLsDFHd1 tmp_l1bQQaOaUi2 tmp_Nx36B1jZZ43 |
	tmp_l1bQQaOaUi1 := a b.
	tmp_ga4aLsDFHd2 := tmp_l1bQQaOaUi1 c.
	tmp_Nx36B1jZZ43 := e f.
	d := tmp_Nx36B1jZZ43 g'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assertMethodSourceCode: (SAASTHelper new renameTempVars: astBefore formattedCode)
		equals: (SAASTHelper new renameTempVars: codeAfter)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testDuplicateMessages [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom: 'foo | c |
	c := PolishCalculator new.
	c one.
	c two.
	c sub.
	c add.
	c add.'.
	astAfter := self astHelper
		parsedMethodFrom:
			'foo
	| c tmp_4i9DOj2lF61 tmp_NqD683Ca6d2 tmp_QzSdLqXCVx3 tmp_MAHhbR3cR04 tmp_cXmrihy6UX5 |
	c := PolishCalculator new.
	tmp_4i9DOj2lF61 := c one.
	tmp_NqD683Ca6d2 := c two.
	tmp_QzSdLqXCVx3 := c sub.
	tmp_MAHhbR3cR04 := c add.
	tmp_cXmrihy6UX5 := c add'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assert: (SAASTHelper new renameTempVars: astBefore dump)
		equals: (SAASTHelper new renameTempVars: astAfter dump)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testErrorIssue52 [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom:
			'testBlockAcceptsEpsilon
	| block |
	block := [ :context | context next ] asPParser
					isNullable: true;
					yourself.
	self assertIsNullable: block.'.
	astAfter := self astHelper
		parsedMethodFrom:
			'testBlockAcceptsEpsilon
	| block tmp_otfhqPipwW1 tmp_YOYqpSxkYU2 tmp_cEOZWmuP0a3 |
	tmp_otfhqPipwW1 := [ :context | context next ] asPParser.
	tmp_YOYqpSxkYU2 := tmp_otfhqPipwW1 isNullable: true.
	block := tmp_otfhqPipwW1 yourself.
	tmp_cEOZWmuP0a3 := self assertIsNullable: block'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assert: (SAASTHelper new renameTempVars: astBefore dump)
		equals: (SAASTHelper new renameTempVars: astAfter dump)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testErrorIssue53 [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom:
			'foo
	| chars |
	chars := (String new writeStream)
				nextPut: $A;
				nextPut: $B;
				nextPut: $C;
				contents.
	chars class inspect'.
	astAfter := self astHelper
		parsedMethodFrom:
			'foo
	| chars tmp_EI34hEWtwF1 tmp_ToBQBsvSUq2 tmp_Lx6R0VeYP83 tmp_ID6bAqYqas4 tmp_zFdPw5Tgxu5 tmp_cG5uAfRkyc6 tmp_WhozcPPC0D7 |
	tmp_ToBQBsvSUq2 := String new.
	tmp_EI34hEWtwF1 := tmp_ToBQBsvSUq2 writeStream.
	tmp_Lx6R0VeYP83 := tmp_EI34hEWtwF1 nextPut: $A.
	tmp_ID6bAqYqas4 := tmp_EI34hEWtwF1 nextPut: $B.
	tmp_zFdPw5Tgxu5 := tmp_EI34hEWtwF1 nextPut: $C.
	chars := tmp_EI34hEWtwF1 contents.
	tmp_cG5uAfRkyc6 := chars class.
	tmp_WhozcPPC0D7 := tmp_cG5uAfRkyc6 inspect'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assert: (SAASTHelper new renameTempVars: astBefore dump)
		equals: (SAASTHelper new renameTempVars: astAfter dump)
]

{ #category : #test }
SAMethodNormalizingRewriterTest >> testExtractVariableFrom [
	| ins node1 node2 node3 node4 node5 node6 |
	ins := SAMethodNormalizingRewriter new.
	node1 := RBParser parseExpression: 'y'.
	node2 := RBParser parseExpression: 'y := 1'.
	node3 := RBParser parseExpression: '1'.
	node4 := RBParser parseExpression: 'Array'.
	node5 := RBParser parseExpression: 'x := (y:=1) + 1.'.
	node6 := RBParser parseExpression: '(y:=1) + 1.'.
	self assert: (ins extractVariableFrom: node1) name equals: 'y'.
	self assert: (ins extractVariableFrom: node2) name equals: 'y'.
	self
		assert: ((ins extractVariableFrom: node3) name beginsWith: 'tmp').
	self
		assert: ((ins extractVariableFrom: node4) name beginsWith: 'tmp').
	self assert: (ins extractVariableFrom: node5) name equals: 'x'.
	self
		assert: ((ins extractVariableFrom: node6) name beginsWith: 'tmp').
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testIntNormalizer [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom:
			'testFromBottom
	| es |
	es := (10 to: 100 by: 10)
		collect: [ :n | 
			RSBox new
				size: n;
				yourself ]'.
	astAfter := 'testFromBottom
	| es tmp_XU7VULfHBa1 |
	tmp_XU7VULfHBa1 := 10 to: 100 by: 10.
	es := tmp_XU7VULfHBa1
		collect: [ :n | 
			RSBox new
				size: n;
				yourself ]'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assertMethodSourceCode: (SAASTHelper new renameTempVars: astBefore formattedCode)
		equals: (SAASTHelper new renameTempVars: astAfter)
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testNoNormalize [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom: 'foo a:=1. Array with:1'.
	astAfter := self astHelper
		parsedMethodFrom:
			'foo
	| tmp_XU7VULfHBa1 |
	a := 1.
	tmp_XU7VULfHBa1 := Array with: 1'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assertMethodSourceCode: (SAASTHelper new renameTempVars: astBefore formattedCode )
		equals: (SAASTHelper new renameTempVars: astAfter formattedCode)
]

{ #category : #test }
SAMethodNormalizingRewriterTest >> testNormalizeAssignmentAssignTo [
	| node1 ins node2 node3 node4 node5 node6 |
	ins := SAMethodNormalizingRewriter new.
	node1 := RBParser parseExpression: 'x := 1'.
	node2 := RBParser parseExpression: 'y := (x := 1) + 1'.
	node3 := RBParser parseExpression: 'y := (x := 1)'.
	node4 := RBParser parseExpression: 'x := y + 1'.
	node5 := RBParser parseExpression: 'y + 1'.
	node6 := RBParser parseExpression: 'y'.
	self
		assertCollection:
			((node1 smallAmpNormalizeWith: ins assignTo: nil)
				collect: #formattedCode) asArray
		equals: {'x := 1'}.
	self
		assertCollection:
			((node2 smallAmpNormalizeWith: ins assignTo: nil)
				collect: #formattedCode) asArray
		equals: {'x := 1' . 'y := x + 1'}.
	self
		assertCollection:
			((node3 smallAmpNormalizeWith: ins assignTo: nil)
				collect: #formattedCode) asArray
		equals: {'x := 1' . 'y := x'}.
	self
		assertCollection:
			((node4 smallAmpNormalizeWith: ins assignTo: nil)
				collect: #formattedCode) asArray
		equals: {'x := y + 1'}.
	self
		assertCollection:
			((node5 smallAmpNormalizeWith: ins assignTo: nil)
				collect: [ :s | SAASTHelper new renameTempVars: s formattedCode ])
				asArray
		equals: {'tmp1 := y + 1'}.
	self
		assertCollection:
			((node6 smallAmpNormalizeWith: ins assignTo: nil)
				collect: [ :s | SAASTHelper new renameTempVars: s formattedCode ])
				asArray
		equals: {}
]

{ #category : #tests }
SAMethodNormalizingRewriterTest >> testSelf [
	| astBefore astAfter |
	astBefore := self astHelper
		parsedMethodFrom:
			'testAnd

	| grammar prs |
	grammar := ''Grammar <- &("Foo Bar") "Foo"''.
	prs := self grammar: grammar start: ''Grammar''.
	self
		assert: prs fail: ''Foo'';
		assert: prs parse: ''Foo Bar'' to: #(''Foo Bar'' ''Foo'') end: 3'.
	astAfter := 'testAnd
	| grammar prs tmp_Axq1NOJndZ1 tmp_Axq1NOJndZ2 |
	grammar := ''Grammar <- &("Foo Bar") "Foo"''.
	prs := self grammar: grammar start: ''Grammar''.
	tmp_Axq1NOJndZ2 := self assert: prs fail: ''Foo''.
	tmp_Axq1NOJndZ1 := self
		assert: prs
		parse: ''Foo Bar''
		to: #(''Foo Bar'' ''Foo'')
		end: 3'.
	SAMethodNormalizingRewriter runWith: astBefore.
	self
		assertMethodSourceCode: (SAASTHelper new renameTempVars: astBefore formattedCode)
		equals: (SAASTHelper new renameTempVars: astAfter)
]
