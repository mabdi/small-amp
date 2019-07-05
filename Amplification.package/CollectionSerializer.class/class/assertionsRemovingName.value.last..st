as yet unclassified
assertionsRemovingName: aName value: aValue last: theLast
	| a b d theObject assertStatement |
	theLast ifNil: [ ^ {} ].
	a := (aValue at: #value) copy.
	b := (theLast at: #value) copy.
	a size = (b size - 1)
		ifFalse: [ ^ {} ].
	a add: nil.
	d := OrderedCollection new.
	b
		doWithIndex: [ :obj :i | 
			(obj at: #type) = #primitive
				ifTrue:[((a at: i - d size) isNil
				or: [ ((SerializerFactory getUnserializer: obj)
						isEqualWith: (a at: i - d size)) not ])
				ifTrue: [ d ifNotEmpty: [ ^ {} ].
					d add: i ]] ].
	d ifEmpty: [ ^ {} ].
	d := d at: 1.
	theObject := RBMessageNode
		receiver: (RBVariableNode named: aName)
		selector: #at:
		arguments: {(RBLiteralValueNode value: d)}.
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #deny:equals:
		arguments:
			{theObject.
			(RBLiteralValueNode
				value: (SerializerFactory unserialize: (b at: d)))}.
	^ {assertStatement}