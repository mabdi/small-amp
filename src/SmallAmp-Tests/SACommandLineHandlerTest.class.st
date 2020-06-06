"
A SACommandLineHandlerTest is a test class for testing the behavior of SACommandLineHandler
"
Class {
	#name : #SACommandLineHandlerTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #test }
SACommandLineHandlerTest >> testMetricsEval [
	SACommandLineHandler new metricsEval: 'mutalk'.
	self  assert: (FileLocator imageDirectory / 'mutalk.stat') exists
]
