accessing
selectors
	^ selectorOperator
		ifNil: [ selectorOperator := {SmallAmpSelector new.
			} ]