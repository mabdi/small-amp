"
Amplification initializeWithTests: UUIDGeneratorTests target: {UUIDGenerator}




Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	improvmentAlgorithm:		<Object>
	testClass:		<Object>
	testTarget:		<Object>


    Implementation Points
"
Class {
	#name : #SmallAmp,
	#superclass : #Object,
	#instVars : [
		'mainLoop',
		'testMethods',
		'testTargets',
		'testClass',
		'newTestClass',
		'minifiedTestClass',
		'minifiedAddedTestClass',
		'config'
	],
	#category : #'Amplification-Core'
}

{ #category : #example }
SmallAmp class >> example [
	| newTest run1 run2 |
	newTest := (SmallAmp
		initializeWithTests:
			{(#testTargets -> {SmallBank}).
			(#testClass -> SmallBankTest).
			(#GAIteration -> 2)} asDictionary) launch.
	run1 := self mutalkTarget: {SmallBank} testSuite: {SmallBankTest}.
	run2 := self mutalkTarget: {SmallBank} testSuite: {newTest}.
	
]

{ #category : #examples }
SmallAmp class >> example2 [
	| newTest run1 run2 |
	newTest := (SmallAmp
		initializeWithTests:
			{(#testTargets -> {SmallBank2}).
			(#testClass -> SmallBank2Test).
			(#GAIteration -> 2)} asDictionary) launch.
	run1 := self mutalkTarget: {SmallBank2} testSuite: {SmallBank2Test}.
	run2 := self mutalkTarget: {SmallBank2} testSuite: {newTest}.
	
]

{ #category : #'as yet unclassified' }
SmallAmp class >> getPairsForPackage: aPackageNameString [
	| ins clsss |
	ins := self new.
	clsss := aPackageNameString asPackage classes select: #isTestCase.
	^ clsss collect: [ :cls | cls -> (ins guessTestTargetFor: cls) ]
]

{ #category : #'as yet unclassified' }
SmallAmp class >> getPairsForPackagePrefix: aPrefix [
	| pkgs ins clsss |
	ins := self new.
	pkgs := RPackageOrganizer default packageNames
		select: [ :n | n matchesRegex: aPrefix ].
	clsss := pkgs
		inject: OrderedCollection new
		into: [ :res :pkg | 
			res addAll: (pkg asPackage classes select: #isTestCase).
			res ].
	^ clsss collect: [ :cls | cls -> (ins guessTestTargetFor: cls) ]
]

{ #category : #'as yet unclassified' }
SmallAmp class >> getStringPairsForPackagePrefix: aPrefix [
	| pairs |
	pairs := self getPairsForPackagePrefix: aPrefix.
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: 'testTargtsMapping';
				cr;
				nextPutAll: '"generatedBy: `AmplificationHelper getStringPairsForPackagePrefix: ''';
				nextPutAll: aPrefix;
				nextPutAll: '''`"';
				cr;
				nextPutAll: '| list |';
				cr;
				nextPutAll: 'list := OrderedCollection new.';
				cr.
			pairs
				do: [ :p | 
					| c |
					c := ''.
					p value ifNil: [ c := '"' ].
					s
						nextPutAll: c;
						nextPutAll: 'list add: ';
						nextPutAll: p asString;
						nextPutAll: '.';
						nextPutAll: c;
						cr ].
			s nextPutAll: '^ list.' ]
]

{ #category : #'as yet unclassified' }
SmallAmp class >> guessTestTargetFor: aTestClass [
	^ self new guessTestTargetFor: aTestClass
]

{ #category : #initialization }
SmallAmp class >> initializeWith: aConfig [
	^ self new initializeWith: aConfig
]

{ #category : #initialization }
SmallAmp class >> initializeWith: aConfig toAmplify: aList [
	^ self new initializeWith: aConfig toAmplify: aList
]

{ #category : #initialization }
SmallAmp class >> initializeWithTests: dicConfig [
	^ self new initializeWithTests: dicConfig
]

{ #category : #'as yet unclassified' }
SmallAmp class >> mutalkTarget: aClass testSuite: aTestSuite [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: aTestSuite
		mutating: aClass
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1
]

{ #category : #'as yet unclassified' }
SmallAmp >> amplify: aTestClass target: aTargetClass [
	| amp newTest run1 run2 minifiedTestClass run3 run4 minifiedAddedTestClass |
	self flag: #TODO. "Reify the concept of test configuration as an object."
	self flag: #TODO. "Reify the concept of amplification result as an object."
	amp := SmallAmp
		initializeWithTests:
			{(#testTargets -> {aTargetClass}).
			(#testClass -> aTestClass).
			(#GAIteration -> 2)} asDictionary.
	amp launch.
	newTest := amp newTestClass.
	minifiedTestClass := amp minifiedTestClass.
	minifiedAddedTestClass := amp minifiedAddedTestClass.
	ASTHelper new
		renameClass: newTest
		name: aTestClass name , 'AmpTest'.
	ASTHelper new
		renameClass: minifiedTestClass
		name: aTestClass name , 'MinAmpTest'.
	ASTHelper new
		renameClass: minifiedAddedTestClass
		name: aTestClass name , 'MinAddAmpTest'.
	run1 := self mutalkTarget: {aTargetClass} testSuite: {aTestClass}.
	run2 := self mutalkTarget: {aTargetClass} testSuite: {newTest}.
	run3 := self
		mutalkTarget: {aTargetClass}
		testSuite: {minifiedTestClass}.
	run4 := self
		mutalkTarget: {aTargetClass}
		testSuite: {minifiedAddedTestClass}.
	^ {run1.
	run2.
	run3.
	run4}
]

{ #category : #'as yet unclassified' }
SmallAmp >> amplifyAll [
	^ self amplifyAll: self testTargetsMapping
]

{ #category : #'as yet unclassified' }
SmallAmp >> amplifyAll: aList [
	| res |
	res := OrderedCollection new.
	aList
		do:
			[ :item | res add: item -> (self amplify: item key target: item value) ]
		displayingProgress: [ :item | 'Processing ' , item key name ].
	^ res
]

{ #category : #'as yet unclassified' }
SmallAmp >> classifyMethods [
	testTargets
		do:
			[ :anObjectUnderTest | SAMethodClassifier classifyClass: anObjectUnderTest ]
]

{ #category : #'as yet unclassified' }
SmallAmp >> cleanAndMinifyMethod: methodast [
	| tobecleaned |
	tobecleaned := OrderedCollection new.
	methodast statements
		select: [ :node | 
			node class = RBMessageNode
				and: [ node receiver name = #self
						and: [ node selector asString endsWith: 'description:' ] ] ]
		thenDo: [ :node | 
			node arguments last value = 'Important Assertions'
				ifTrue: [ 
					node
						selector:
							(node selector asString
								copyWithRegex: 'description\:$'
								matchesReplacedWith: '').
					node arguments  removeLast			
								 ]
				ifFalse: [ tobecleaned add: node ] ].
	methodast statements removeAll: tobecleaned
]

{ #category : #'as yet unclassified' }
SmallAmp >> createMdTable: runs [
	| head row detail |
	self flag: #TODO. "Rename method #createMarkdownTable:."
	self flag: #TODO. "Rename argument to be more understandable."
	head := [ :s | 
	s
		nextPutAll: '| Test case | Test target | Original | Amp | AmpMin | AmpMinAdd |';
		cr;
		nextPutAll:
			'| -------- | ----------- | -------- | ----------- | -------- | ----------- |';
		cr ].
	detail := [ :s :d | 
	s nextPutAll: '#TestMethods: '.
	s nextPutAll: ((d at: #testClass) at: 1) testSelectors size asString.
	s nextPutAll: '<br>'.
	s nextPutAll: '#AllMutations: '.
	s
		nextPutAll: (d at: #analysis) generalResult numberOfEvaluatedMutants asString.
	s nextPutAll: '<br>'.
	s nextPutAll: '#KilledMutants: '.
	s
		nextPutAll:
			(d at: #analysis) generalResult numberOfKilledOrTerminatedMutants
				asString.
	s nextPutAll: '<br>'.
	s nextPutAll: 'Score: %'.
	s nextPutAll: (d at: #analysis) generalResult mutationScore asString ].
	row := [ :s :i | 
	s
		nextPutAll: '| ';
		nextPutAll: i key key name;
		nextPutAll: ' | ';
		nextPutAll: i key value name;
		nextPutAll: ' | '.
	detail value: s value: (i value at: 1).
	s nextPutAll: ' | '.
	detail value: s value: (i value at: 2).
	s nextPutAll: ' | '.
	detail value: s value: (i value at: 3).
	s nextPutAll: ' | '.
	detail value: s value: (i value at: 4).
	s nextPutAll: ' | '.
	s cr ].
	^ String
		streamContents: [ :stream | 
			head value: stream.
			runs do: [ :item | row value: stream value: item ] ]
]

{ #category : #'as yet unclassified' }
SmallAmp >> guessTestTargetFor: aTestClass [
	"1. Name
	2. setup TODO
	3. asserted object TODO
	4. manipulated object TODO
	"

	| g |
	(aTestClass name matchesRegex: '.*Test$')
		ifTrue: [ g := aTestClass name copyWithRegex: 'Test$' matchesReplacedWith: ''.
			(SmalltalkImage current hasClassNamed: g)
				ifTrue: [ ^ SmalltalkImage current classNamed: g ] ].
	^ nil
]

{ #category : #accessing }
SmallAmp >> initializeWith: aConfig [
	config := aConfig
]

{ #category : #accessing }
SmallAmp >> initializeWith: aConfig toAmplify: aList [
	self initializeWith: aConfig.
	testClass := aList.
	
]

{ #category : #accessing }
SmallAmp >> initializeWithTests: dicConfig [
	testTargets := dicConfig at: #testTargets.
	testClass := dicConfig at: #testClass.
	testMethods := testClass allTestSelectors.
	mainLoop := SAMainLoop
		initializeWith: testClass
		target: testTargets
		iterations: (dicConfig at: #GAIteration ifAbsent: 3).
	mainLoop testMethods: testMethods
]

{ #category : #actions }
SmallAmp >> launch [
	self preStartActions.
	self startAmplify.
	^ self postStartActions
]

{ #category : #'as yet unclassified' }
SmallAmp >> makeAssertImportant: id atMethod: methodast [
	methodast statements
		do:
			[ :node | 
			(node class = RBMessageNode
				and: [ node receiver name = #self
						and: [ (node selector asString endsWith: 'description:')
								and: [ node arguments last value = (methodast selector asString , ':' , id) ] ] ])
				ifTrue: [ (node arguments at: node arguments size)
						value: 'Important Assertions'
						start: 0
						stop: -1 ] ].
]

{ #category : #actions }
SmallAmp >> makeMinifiedAddedClass [
	| l methods |
	l := [ :cls | cls testSelectors collect: [ :s | (cls methodNamed: s) sourceCode ] ].
	methods := l value: testClass.
	methods := methods
		,
			(l value: minifiedTestClass).
	^ ASTHelper new
		buildTestClassWith: methods
		using: testClass
		final: true
]

{ #category : #actions }
SmallAmp >> makeMinifiedClass [
	| logs methods |
	self mutalkRun: newTestClass target: testTargets.
	methods := Dictionary new.
	logs := newTestClass logs.
	logs sort
		collect: [ :item | item splitOn: ':' ]
		thenDo: [ :item | 
			methods
				at: (item at: 1) asSymbol
				put: (newTestClass methodNamed: (item at: 1) asSymbol) ast ].
	logs sort
		collect: [ :item | item splitOn: ':' ]
		thenDo: [ :item | 
			self
				makeAssertImportant: (item at: 2)
				atMethod: (methods at: (item at: 1) asSymbol) ].
	newTestClass logs removeAll.
	methods values do: [ :m | self cleanAndMinifyMethod: m ].
	^ ASTHelper new
		buildTestClassWith: (methods values collect: [ :m | m formattedCode ])
		using: testClass
		final: true
]

{ #category : #actions }
SmallAmp >> minifiedAddedTestClass [
	^ minifiedAddedTestClass
]

{ #category : #actions }
SmallAmp >> minifiedTestClass [
^ minifiedTestClass
]

{ #category : #'as yet unclassified' }
SmallAmp >> mutalkRun: aClass [
	| targetClasses analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1
]

{ #category : #'as yet unclassified' }
SmallAmp >> mutalkRun: aClass target: targetClasses [
	|  analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: {aClass}
		mutating: targetClasses
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1
]

{ #category : #'as yet unclassified' }
SmallAmp >> mutalkTarget: aClass testSuite: aTestSuite [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: aTestSuite
		mutating: aClass
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ {(#analysis -> analysis1).
	(#testClass -> aTestSuite).
	(#testTarget -> aClass)} asDictionary
]

{ #category : #accessing }
SmallAmp >> newTestClass [
	^ newTestClass
]

{ #category : #actions }
SmallAmp >> postStartActions [
	minifiedTestClass := self makeMinifiedClass.
	minifiedAddedTestClass := self makeMinifiedAddedClass.
	^ newTestClass
]

{ #category : #actions }
SmallAmp >> preStartActions [
	| result |
	self classifyMethods. 
	result := testClass suite run.
	testTargets
		do:
			[ :atarg | atarg methods do: [ :mtd | ObservationProxy fixMethod: mtd ] ].
	testMethods := result passed
		collect: [ :passed | 
			(testClass methods detect: [ :m | m selector = passed selector ])
				sourceCode ].
	mainLoop testMethods: testMethods
]

{ #category : #actions }
SmallAmp >> startAmplify [
	newTestClass := mainLoop start
]

{ #category : #tests }
SmallAmp >> testTargetsMapping [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
SmallAmp >> visualizeAmplification2: aList [
	| browser |
	browser := GLMTabulator new.
	browser
		row: [ :r | 
			r
				column: #testclasses;
				column: #amplifiedversions;
				column: #mutantTypes;
				column: #mutants ];
		row: #diff;
		row: [ :r | 
			r
				column: #methods;
				column: #sourceCode ].
	browser transmit
		to: #testclasses;
		andShow: [ :a | 
			a list
				display: [ :pair | pair ];
				format: [ :pair | pair key key name ] ].
	browser transmit
		to: #amplifiedversions;
		from: #testclasses;
		andShow: [ :a | 
			a list
				display: [ :pair | pair value ];
				format: [ :run | (run at: #testClass) first name ] ].
	browser transmit
		to: #mutantTypes;
		from: #amplifiedversions;
		andShow: [ :a | 
			a list
				display: [ :dic | 
					| r size ks ls ts |
					r := (dic at: #analysis) generalResult.
					size := r killedMutants size + r aliveMutants size
						+ r terminatedMutants size.
					ks := 0.
					ls := 0.
					ts := 0.
					size > 0
						ifTrue: [ ks := 100 * (r killedMutants size / size) truncateTo: 0.01.
							ls := 100 * (r aliveMutants size / size) truncateTo: 0.01.
							ts := 100 * (r terminatedMutants size / size) truncateTo: 0.01 ].
					{(('Killed %' , ks asString) -> r killedMutants).
					(('Alive %' , ls asString) -> r aliveMutants).
					(('Terminated %' , ts asString) -> r terminatedMutants)} ];

				format: [ :row | row key ] ].
	browser transmit
		to: #mutants;
		from: #mutantTypes;
		andShow: [ :a | a list display: [ :pair | pair value ] ].
	browser transmit
		to: #diff;
		from: #mutants;
		andShow: [ :a | 
			a diff
				display: [ :mutant | 
					{(RBParser parseMethod: mutant mutant originalSource) formattedCode.
					(RBParser parseMethod: mutant mutant modifiedSource)
						formattedCode} ] ].
	browser transmit
		to: #methods;
		from: #amplifiedversions;
		andShow: [ :a | 
			a list
				display: [ :dic | (dic at: #testClass) first methods ];
				format: [ :m | m selector ] ].
	browser transmit
		to: #sourceCode;
		from: #methods;
		andShow: [ :a | a text display: [ :method | method sourceCode ] ].
	browser openOn: aList
]

{ #category : #'as yet unclassified' }
SmallAmp >> visualizeAmplification: aList [
	| browser |
	browser := GLMTabulator new.
	browser
		row: [ :r | 
			r
				column: #testclasses;
				column: #amplifiedversions;
				column: #killed;
				column: #survived;
				column: #terminated ];
		row: #diff;
		row: [ :r | 
			r
				column: #methods;
				column: #sourceCode ].
	browser transmit
		to: #testclasses;
		andShow: [ :a | 
			a list
				display: [ :pair | pair ];
				format: [ :pair | pair key key name ] ].
	browser transmit
		to: #amplifiedversions;
		from: #testclasses;
		andShow: [ :a | 
			a list
				display: [ :pair | pair value ];
				format: [ :run | (run at: #testClass) first name ] ].
	browser transmit
		to: #killed;
		from: #amplifiedversions;
		andShow: [ :a | 
			a list
				display: [ :dic | (dic at: #analysis) generalResult killedMutants ] ].
	browser transmit
		to: #survived;
		from: #amplifiedversions;
		andShow: [ :a | 
			a list
				display: [ :dic | (dic at: #analysis) generalResult aliveMutants ] ].
	browser transmit
		to: #terminated;
		from: #amplifiedversions;
		andShow: [ :a | 
			a list
				display: [ :dic | (dic at: #analysis) generalResult terminatedMutants ] ].
	browser transmit
		to: #diff;
		from: #survived;
		andShow: [ :a | 
			a diff
				display: [ :mutant | 
					{(RBParser parseMethod: mutant mutant originalSource) formattedCode.
					(RBParser parseMethod: mutant mutant modifiedSource)
						formattedCode} ] ].
	browser transmit
		to: #diff;
		from: #killed;
		andShow: [ :a | 
			a diff
				display: [ :mutant | 
					{(RBParser parseMethod: mutant mutant originalSource) formattedCode.
					(RBParser parseMethod: mutant mutant modifiedSource)
						formattedCode} ] ].
	browser transmit
		to: #diff;
		from: #terminated;
		andShow: [ :a | 
			a diff
				display: [ :mutant | 
					{(RBParser parseMethod: mutant mutant originalSource) formattedCode.
					(RBParser parseMethod: mutant mutant modifiedSource)
						formattedCode} ] ].
	browser transmit
		to: #methods;
		from: #amplifiedversions;
		andShow: [ :a | 
			a list
				display: [ :dic | (dic at: #testClass) first methods ];
				format: [ :m | m selector ] ].
	browser transmit
		to: #sourceCode;
		from: #methods;
		andShow: [ :a | a text display: [ :method | method sourceCode ] ].
	browser openOn: aList
]
