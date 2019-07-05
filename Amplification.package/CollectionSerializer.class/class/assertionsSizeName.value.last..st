as yet unclassified
assertionsSizeName: aName value: aValue last: theLast
	| assertStatement theObject theValue |
	
	(theLast isNil or: [ (aValue at: #value) size ~= (theLast at: #value) size ])
		ifFalse: [ ^ {} ].
	theObject := RBMessageNode
		receiver: (RBVariableNode named: aName)
		selector: #size.
	theValue := RBLiteralValueNode value: (aValue at: #value) size.
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValue}.
	^ {assertStatement}