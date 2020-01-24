"
I am a copy of class DTTestCoverageConfiguration. This comment is copied from there, and might not be entirely accurate

I know the items to create a testSuite that will be analysed by a DrTestsPlugin.
"
Class {
	#name : #SADrTestsConfiguration,
	#superclass : #DTPluginConfiguration,
	#category : #'SmallAmp-DrTests'
}

{ #category : #tests }
SADrTestsConfiguration >> testMethods [
	^ (packagesSelected
		flatCollect:
			[ :p | p definedClasses select: [ :c | c allSuperclasses includes: TestCase ] ])
		flatCollect: 
		[ :c | c methods select:[:m| m isTestMethod ] ]
]
