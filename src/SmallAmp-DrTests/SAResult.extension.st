Extension { #name : #SAResult }

{ #category : #'*SmallAmp-DrTests' }
SAResult >> aliveMutants [
	| subs |
	subs := self results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults:
					{(DTTreeNode new
						name: 'Alive mutants in original:';
						subResults: (x aliveMutantsInOriginal collect: #asResultForDrTest);
						yourself).
					(DTTreeNode new
						name: 'Killed mutants in amplified';
						subResults: (x killedMutantsInAmplified collect: #asResultForDrTest);
						yourself).
					(DTTreeNode new
						name: 'Still alive mutants in amplified';
						subResults:
							(x stillAliveMutants 
								collect: #asResultForDrTest);
						yourself)};
				yourself ].
	^ DTTreeNode new
		name: 'Mutants';
		subResults: subs;
		yourself
]

{ #category : #'*SmallAmp-DrTests' }
SAResult >> amplifiedClasses [
	| subs |
	subs := self results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults:
					{(DTTreeNode new
						name: 'Original (' , x testClass name , '):';
						subResults: (x originalMethods collect: #asResultForDrTest);
						yourself).
					(DTTreeNode new
						name: 'Amplified (' , x amplifiedClass name , '):';
						subResults: (x amplifiedMethods collect: #asResultForDrTest);
						yourself)};
				yourself ].
	^ DTTreeNode new
		name: 'Amplified TestCase';
		subResults: subs;
		yourself
]

{ #category : #'*SmallAmp-DrTests' }
SAResult >> mutationScores [
	| subs |
	subs := self results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults:
					{(DTTreeNode new
						name:
							'Original: ' , x testClass name , ': %'
								, x originalMutationScore asString;
						subResults: {};
						yourself).
					(DTTreeNode new
						name:
							'Amplified: ' , x amplifiedClass name , ': %'
								, x amplifiedMutationScore asString;
						subResults: {};
						yourself)};
				yourself ].
	^ DTTreeNode new
		name: 'Mutation scores';
		subResults: subs;
		yourself
]

{ #category : #'*SmallAmp-DrTests' }
SAResult >> notProfiledMethods [
	| subs |
	subs := self results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults: (x methodsNotProfiled collect: #asResultForDrTest);
				yourself ].
	^ DTTreeNode new
		name: 'Methods failed to be profiled:';
		subResults: subs;
		yourself
]

{ #category : #'*SmallAmp-DrTests' }
SAResult >> skippedTestMethods [
	| subs |
	subs := self results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults: (x failedSelectorInOriginal collect: #asResultForDrTest);
				yourself ].
	^ DTTreeNode new
		name: 'Skipped test methods';
		subResults: subs;
		yourself
]

{ #category : #'*SmallAmp-DrTests' }
SAResult >> timeInformations [
	| subs |
	subs := self results values
		collect: [ :x | 
			| sums |
			sums := x detailedTimeLabel
				collect: [ :s | 
					DTTreeNode new
						name: s;
						subResults: {};
						yourself ].
			DTTreeNode new
				name: x totalTimeLabel;
				subResults: sums;
				yourself ].
	^ DTTreeNode new
		name: 'Running time: ';
		subResults: subs;
		yourself
]
