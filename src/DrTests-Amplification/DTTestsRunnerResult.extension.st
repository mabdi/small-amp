Extension { #name : #DTTestsRunnerResult }

{ #category : #'*DrTests-Amplification' }
DTTestsRunnerResult >> buildAmplificationResultTree [
	<dTTestRunnerResultTreeNamed: 'Group by SmallAmp'>
	self flag: #TODO. "This is a prototype to show ho to integrate SmallAmp in DrTests results."
	^ DTTreeNode new
		subResults:
			{DTTreeNode new
				name: 'Amplified tests';
				subResults:#();
				yourself.
			DTTreeNode new
				name: 'Non-Amplified tests';
				subResults:#();
				yourself.};
		yourself
]
