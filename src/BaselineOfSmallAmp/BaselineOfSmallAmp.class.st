Class {
	#name : #BaselineOfSmallAmp,
	#superclass : #BaselineOf,
	#category : #BaselineOfSmallAmp
}

{ #category : #baselines }
BaselineOfSmallAmp >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		spec
			baseline: 'MuTalk'
			with: [ spec repository: 'github://pavel-krivanek/mutalk/src' ].
		spec package: 'SmallAmp' with: [ spec requires: #( 'MuTalk' ) ].
		spec
			package: 'SmallAmp-Tests'
			with: [ spec requires: #( 'SmallAmp' ) ].
		spec
			package: 'DrTests-SmallAmp'
			with: [ spec requires: #( 'SmallAmp' ) ].
		spec
			package: 'SmallAmp-Spec'
			with: [ spec requires: #( 'SmallAmp' ) ].
		spec
			package: 'SmallAmp-Spec-Tests'
			with: [ spec requires: #( 'SmallAmp-Spec' ) ].
		spec group: 'core' with: #( 'SmallAmp' ).
		spec group: 'ui' with: #( 'core' 'SmallAmp-Spec' ).
		spec
			group: 'tests'
			with: #( 'core' 'SmallAmp-Tests' 'SmallAmp-Spec-Tests' ) ]
]