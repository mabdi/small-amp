private
serialize: anObject depth: anInt
	| result |
	result := Dictionary new.
	result at: #rowCount put: anObject rowCount.
	result at: #columnCount put: anObject columnCount.
	^ result