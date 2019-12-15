Class {
	#name : #BaselineOfAmplification,
	#superclass : #BaselineOf,
	#category : #BaselineOfSmallAmp
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
			spec package: 'DrTests-Amplification' with: [ spec requires: #('Amplification') ].
			spec package: 'Amplification-Spec' with: [ spec requires: #('Amplification') ].
			spec package: 'Amplification-Spec-Tests' with: [ spec requires: #('Amplification-Spec') ].
		spec group: 'core' with: #('Amplification').
		spec group: 'ui' with: #('core' 'Amplification-Spec').
		spec group: 'tests' with: #('core' 'AmplificationTests' 'Amplification-Spec-Tests'). ]
]
