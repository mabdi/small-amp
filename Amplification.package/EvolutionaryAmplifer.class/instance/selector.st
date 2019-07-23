accessing
selector
	^ selectorOperator ifNil: [ selectorOperator := DspotSelector  new ]