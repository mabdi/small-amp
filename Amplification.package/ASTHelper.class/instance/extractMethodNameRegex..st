as yet unclassified
extractMethodNameRegex: aSourceCode
	| re |
	re := '^(\S+)(\:|\s).*' asRegex.
	re matchesPrefix: aSourceCode.
	^ ((re subexpression: 2) splitOn: ':') at: 1