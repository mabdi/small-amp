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
			baseline: 'SmallBank'
			with: [ spec repository: 'github://mabdi/smalltalk-SmallBank/src' ].
		spec
			baseline: 'MuTalk'
			with: [ spec repository: 'github://mabdi/mutalk/src' ].
		spec package: 'SmallAmp' with: [ spec requires: #( 'MuTalk' ) ].
		spec
			package: 'SmallAmp-Tests'
			with: [ spec requires: #( 'SmallAmp' 'SmallBank' ) ].
		spec
			package: 'SmallAmp-DrTests'
			with: [ spec requires: #( 'SmallAmp' ) ].
		spec
			package: 'SmallAmp-Complementary'
			with: [ spec requires: #( 'SmallAmp' ) ].
		spec
			package: 'SmallAmp-Complementary-Tests'
			with: [ spec requires: #( 'SmallAmp-Complementary' ) ].
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
