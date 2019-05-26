asserting
assertGenerateFor: anObservation basedOn: theLast
	| assertStatement theObject theValue |
	theObject := RBMessageNode
		receiver: (RBVariableNode named: (anObservation at: #name))
		selector: #asString.
	theValue := RBLiteralValueNode value: (anObservation at: #value).
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValue}.
	^ {assertStatement}