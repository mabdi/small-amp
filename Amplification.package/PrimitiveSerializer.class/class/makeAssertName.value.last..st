asserting
makeAssertName: aName value: aValue last: theLast
	| assertStatement theObject theValue |
	theObject := RBVariableNode named: aName.
	theValue := RBLiteralValueNode
		value: (SerializerFactory unserialize: aValue).
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValue}.
	^ {assertStatement}