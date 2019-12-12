Class {
	#name : #SAResult,
	#superclass : #Object,
	#category : #'Amplification-Model'
}

{ #category : #'as yet unclassified' }
SAResult class >> mutalkTarget: aClass testSuite: aTestSuite [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: aTestSuite
		mutating: aClass
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1
]

{ #category : #adding }
SAResult >> addResult: aResultItem for: aTestClass [
]

{ #category : #'as yet unclassified' }
SAResult >> createMdTable: runs [
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
SAResult >> visualizeAmplification2: aList [
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
