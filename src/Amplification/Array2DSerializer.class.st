Class {
	#name : #Array2DSerializer,
	#superclass : #CollectionSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
Array2DSerializer class >> myTag [
	^ #array2d
]

{ #category : #accessing }
Array2DSerializer class >> priority [
	^ 19
]

{ #category : #'as yet unclassified' }
Array2DSerializer class >> supportingTypes [
	^ {Array2D}
]

{ #category : #'as yet unclassified' }
Array2DSerializer class >> unserialize: dictionary [
	| rowCount columnCount matrix |
	rowCount := (dictionary at: #extra) at: #rowCount.
	columnCount := (dictionary at: #extra) at: #columnCount.
	matrix := Array2D rows: rowCount columns: columnCount.
	1 to: rowCount do: [ :row | 
		1 to: columnCount do: [ :column | 
			| i |
			i := matrix indexForRow: row andColumn: column.
			matrix
				at: row
				at: column
				put: (SerializerFactory unserialize: ((dictionary at: #value) at: i)) ] ].
	^ matrix
]

{ #category : #private }
Array2DSerializer >> serializeDepth: anInt [
	| result extra |
	result := super serializeDepth: anInt.
	extra := Dictionary  new.
	extra at: #rowCount put: object rowCount.
	extra at: #columnCount put: object columnCount.
	result at: #extra put: extra.
	^ result
]
