Extension { #name : #SAResult }

{ #category : #'*SmallAmp-DrTests' }
SAResult >> amplifiedClasses [

	| subs |
	subs := self results values collect: [ :x | 
		        DTTreeNode new
			        name: x testClass name;
			        subResults: { 
					        (DTTreeNode new
						         name: 'Original (' , x testClass name , '):';
						         subResults:
							         (x originalMethods collect: #asResultForDrTest);
						         yourself).
					        (DTTreeNode new
						         name: 'Amplified (' , x amplifiedClass name , '):';
						         subResults:
							         (x amplifiedCompiledMethods collect: #asResultForDrTest);
						         yourself) };
			        yourself ].
	^ DTTreeNode new
		  name: 'Amplified TestCase';
		  subResults: subs;
		  yourself
]

{ #category : #'*SmallAmp-DrTests' }
SAResult >> coverage [
	| subs |
	subs := self results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults:
					{(DTTreeNode new
						name: 'Not covered in original:';
						subResults: (x notCoveredInOriginal collect: #asResultForDrTest);
						yourself).
					(DTTreeNode new
						name: 'Newly covered in amplified';
						subResults: (x newCovered collect: #asResultForDrTest);
						yourself).
					(DTTreeNode new
						name: 'Not covered in amplified';
						subResults: (x notCoveredInAmplified collect: #asResultForDrTest);
						yourself)};
				yourself ].
	^ DTTreeNode new
		name: 'Coverage';
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
SAResult >> scores [
	| subs |
	subs := self results values
		collect: [ :x | 
			DTTreeNode new
				name: x testClass name;
				subResults:
					{(DTTreeNode new
						name:
							'Original: ' , x testClass name , ': %'
								, x originalScore asString;
						subResults: {};
						yourself).
					(DTTreeNode new
						name:
							'Amplified: ' , x amplifiedClass name , ': %'
								, x amplifiedScore asString;
						subResults: {};
						yourself)};
				yourself ].
	^ DTTreeNode new
		name: 'Scores';
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
