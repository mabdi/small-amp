asserting
makeAssertName: aName value: aValue last: theLast
	| assertStatements |
	assertStatements := OrderedCollection new.
	assertStatements
		addAll: (self assertionsSizeName: aName value: aValue last: theLast).
	assertStatements
		addAll: (self assertionsAddingName: aName value: aValue last: theLast).
	assertStatements
		addAll: (self assertionsUpdatingName: aName value: aValue last: theLast).
	assertStatements	
		addAll: (self assertionsRemovingName: aName value: aValue last: theLast).
	^ assertStatements