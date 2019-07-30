as yet unclassified
fixMethod: aMethod
	(aMethod isKindOf: self)
				ifTrue: [ aMethod methodClass methodDict at: aMethod selector put: aMethod method ]