removing
insertRandom: aStr
	| x |
	x := aStr size atRandom.
	^ (aStr copyFrom: 1 to: x) , self characterSet atRandom asString
		, (aStr copyFrom: x + 1 to: aStr size)