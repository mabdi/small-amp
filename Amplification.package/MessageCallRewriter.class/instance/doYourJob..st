as yet unclassified
doYourJob: aMethod
	self visitNode: aMethod.
	self addTemporaryVariables: self targetNodes size to: aMethod.
	self convertToAssignments: aMethod.