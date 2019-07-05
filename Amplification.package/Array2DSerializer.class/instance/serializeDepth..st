private
serializeDepth: anInt
	| result extra |
	result := super serializeDepth: anInt.
	extra := Dictionary  new.
	extra at: #rowCount put: object rowCount.
	extra at: #columnCount put: object columnCount.
	result at: #extra put: extra.
	^ result