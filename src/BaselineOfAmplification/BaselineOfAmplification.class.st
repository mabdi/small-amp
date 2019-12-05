Class {
	#name : #BaselineOfAmplification,
	#superclass : #BaselineOf,
	#category : #BaselineOfAmplification
}

{ #category : #baselines }
BaselineOfAmplification >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'MuTalk'
				with: [ spec repository: 'github://pavel-krivanek/mutalk/src' ].
			spec package: 'Amplification' with: [ spec requires: #('MuTalk') ].
			spec package: 'AmplificationTests' with: [ spec requires: #('Amplification') ].
			spec package: 'DrTests-Amplification' with: [ spec requires: #('Amplification') ] ]
]
