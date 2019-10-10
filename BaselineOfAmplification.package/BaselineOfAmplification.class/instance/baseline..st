baselines
baseline: spec
	<baseline>
	spec
		for: #common
		do: [ spec package: 'Amplification' with:[ spec requires: #('MuTalk')].
			spec
				baseline: 'MuTalk'
				with: [ spec repository: 'github://pavel-krivanek/mutalk/src' ] ]