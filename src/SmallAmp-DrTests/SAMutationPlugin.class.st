Class {
	#name : #SAMutationPlugin,
	#superclass : #SADrTestsPlugin,
	#category : #'SmallAmp-DrTests'
}

{ #category : #'api - accessing' }
SAMutationPlugin class >> pluginName [
	^ 'Test Amplification - Mutation coverage (SmallAmp)'
]

{ #category : #'api - accessing' }
SAMutationPlugin class >> pluginResultClass [
	^ SADrTestsResult 
]

{ #category : #'api - accessing' }
SAMutationPlugin class >> weight [
	^ 71
]

{ #category : #'as yet unclassified' }
SAMutationPlugin >> smallAmpDefaultConfig [
	| c |
	c := super smallAmpDefaultConfig.
	^ c
]
