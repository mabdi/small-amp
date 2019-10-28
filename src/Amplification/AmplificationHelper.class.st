Class {
	#name : #AmplificationHelper,
	#superclass : #Object,
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
AmplificationHelper >> amplify: aTestClass target: aTargetClass [
	| amp newTest run1 run2 minifiedTestClass run3 |
	amp := Amplification
		initializeWithTests:
			{(#testTargets -> {aTargetClass}).
			(#testClass -> aTestClass).
			(#GAIteration -> 2)} asDictionary.
	amp launch.
	newTest := amp newTestClass.
	minifiedTestClass := amp minifiedTestClass.
	ASTHelper uniqueInstance
		renameClass: newTest
		name: aTargetClass name , 'AmpTest'.
	ASTHelper uniqueInstance
		renameClass: minifiedTestClass
		name: aTargetClass name , 'MinAmpTest'.
	run1 := self mutalkTarget: {aTargetClass} testSuite: {aTestClass}.
	run2 := self mutalkTarget: {aTargetClass} testSuite: {newTest}.
	run3 := self
		mutalkTarget: {aTargetClass}
		testSuite: {minifiedTestClass}.
	^ {run1.
	run2.
	run3}
]

{ #category : #'as yet unclassified' }
AmplificationHelper >> amplifyAll [
	^ self amplifyAll: self testTargtsMapping
]

{ #category : #'as yet unclassified' }
AmplificationHelper >> amplifyAll: aList [
	^ aList
		collect: [ :item | item -> (self amplify: item key target: item value) ]
]

{ #category : #'as yet unclassified' }
AmplificationHelper >> mutalkTarget: aClass testSuite: aTestSuite [
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

{ #category : #tests }
AmplificationHelper >> testTargtsMapping [
	^ self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
AmplificationHelper >> visualizeAmplification2: aList [
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
AmplificationHelper >> visualizeAmplification: aList [
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
