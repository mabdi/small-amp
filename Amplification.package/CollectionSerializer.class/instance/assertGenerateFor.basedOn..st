asserting
assertGenerateFor: anObservation basedOn: theLast
	"if size is changed -> assert size"

	"is size is +1 -> check adding -> assert added value"
	"is size equal -> check single change -> assert new value"

	| assertStatements |
	assertStatements := OrderedCollection new.
	assertStatements
		addAll: (self assertionsSize: anObservation basedOn: theLast).
	assertStatements
		addAll: (self assertionsAdding: anObservation basedOn: theLast).
	assertStatements
		addAll: (self assertionsUpdating: anObservation basedOn: theLast).
	^ assertStatements