accessing
selector
	^ selectorOperator ifNil: [ selectorOperator := MuTalkSelector new ]