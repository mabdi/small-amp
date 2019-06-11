asserting
assertGenerateFor: anObservation basedOn: theLast
	| assertStatements |
	assertStatements := OrderedCollection new.
	assertStatements
		addAll: (self assertionsSize: anObservation basedOn: theLast).
	assertStatements
		addAll: (self assertionsAdding: anObservation basedOn: theLast).
	assertStatements
		addAll: (self assertionsUpdating: anObservation basedOn: theLast).
	^ assertStatements