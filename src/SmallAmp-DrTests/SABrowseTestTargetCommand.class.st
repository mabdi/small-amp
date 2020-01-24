Class {
	#name : #SABrowseTestTargetCommand,
	#superclass : #DTMiddleListCommand,
	#category : #'SmallAmp-DrTests'
}

{ #category : #testing }
SABrowseTestTargetCommand >> canBeExecuted [
	^ self plugin class = SADrTestsPlugin  and: [self selectedItems size = 1]
]

{ #category : #testing }
SABrowseTestTargetCommand >> execute [
	(SADrTestsRunInput from: self drTest selectedItems first) testTarget first
		drTestsBrowse
]

{ #category : #testing }
SABrowseTestTargetCommand >> initialize [
	super initialize.
	self name: 'Browse Target'
]
