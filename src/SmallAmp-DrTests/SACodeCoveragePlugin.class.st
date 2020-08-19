Class {
	#name : #SACodeCoveragePlugin,
	#superclass : #SADrTestsPlugin,
	#category : #'SmallAmp-DrTests'
}

{ #category : #'api - accessing' }
SACodeCoveragePlugin class >> pluginName [
	^ 'Test Amplification - Code coverage (SmallAmp)'
]

{ #category : #'api - accessing' }
SACodeCoveragePlugin class >> pluginResultClass [
	^ SADrTestsResult
]

{ #category : #'api - accessing' }
SACodeCoveragePlugin class >> weight [
	^ 4
]

{ #category : #'as yet unclassified' }
SACodeCoveragePlugin >> smallAmpDefaultConfig [
	| c |
	c := super smallAmpDefaultConfig.
	c selection: SACodeCoverageSelection.
	^ c
]
