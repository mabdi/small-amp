Class {
	#name : #SABrowseTestTargetCommand,
	#superclass : #DTMiddleListCommand,
	#category : #'SmallAmp-DrTests'
}

{ #category : #testing }
SABrowseTestTargetCommand >> canBeExecuted [
	^ (self plugin class allSuperclasses includes: SADrTestsPlugin)  and: [self selectedItems size = 1]
]

{ #category : #testing }
SABrowseTestTargetCommand >> execute [
	(self drTest selectedItems first) smallAmpTargetClasses
		first drTestsBrowse
]

{ #category : #testing }
SABrowseTestTargetCommand >> initialize [
	super initialize.
	self name: 'Browse Target'
]
