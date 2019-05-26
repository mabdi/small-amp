as yet unclassified
extractMethodName: aSourceCode
	| re |
	re := RBParser parseMethod: aSourceCode.
	^ re selector