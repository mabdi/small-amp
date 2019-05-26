as yet unclassified
assertionsSize: anObservation basedOn: theLast
	
	(theLast isNil
		or: [ (anObservation at: #value) size ~= (theLast at: #value) size ])
		ifTrue: [ | assertStatement theObject theValue |
			theObject := RBMessageNode
				receiver: (RBVariableNode named: (anObservation at: #name))
				selector: #size.
			theValue := RBLiteralValueNode
				value: (anObservation at: #value) size.
			assertStatement := RBMessageNode
				receiver: (RBSelfNode named: 'self')
				selector: #assert:equals:
				arguments:
					{theObject.
					theValue}.
			^ {assertStatement} ]
		ifFalse: [ ^ {} ]