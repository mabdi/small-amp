as yet unclassified
supportingTypes
	^ (self class subclasses
		collect: [ :s | s instance supportingTypes ]) flattened