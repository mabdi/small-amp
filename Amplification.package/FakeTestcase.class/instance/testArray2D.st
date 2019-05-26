tests
testArray2D
	| matrix1 matrix2 matrix23 copyMatrix |
	matrix1 := Array2D new: 2.
	matrix1 at: 1 at: 1 put: 1.
	matrix1 at: 1 at: 2 put: 3.
	matrix1 at: 2 at: 1 put: 2.
	matrix1 at: 2 at: 2 put: 4.
	matrix2 := Array2D new: 2.
	matrix2 at: 1 at: 1 put: 3.
	matrix2 at: 1 at: 2 put: 7.
	matrix2 at: 2 at: 1 put: 4.
	matrix2 at: 2 at: 2 put: 8.
	matrix23 := Array2D rows: 3 columns: 2.
	matrix23 at: 1 at: 1 put: 11.
	matrix23 at: 1 at: 2 put: 21.
	matrix23 at: 2 at: 1 put: 12.
	matrix23 at: 2 at: 2 put: 22.
	matrix23 at: 3 at: 1 put: 13.
	matrix23 at: 3 at: 2 put: 23.
	self should: [ matrix1 at: 2 at: 3 ] raise: Error.
	self should: [ matrix1 at: 3 at: 2 ] raise: Error.
	self should: [ matrix1 at: 3 at: 3 ] raise: Error.
	self should: [ matrix1 at: 0 at: 1 ] raise: Error.
	self should: [ matrix1 at: 1 at: 0 ] raise: Error.
	self should: [ matrix1 at: 0 at: 0 ] raise: Error.
	self assert: (matrix1 at: 1 at: 1) equals: 1.
	self assert: (matrix23 at: 1 at: 1) equals: 11.
	self assert: (matrix23 at: 1 at: 2) equals: 21.
	self assert: (matrix23 at: 2 at: 1) equals: 12.
	self assert: (matrix23 at: 2 at: 2) equals: 22.
	self assert: (matrix23 at: 3 at: 1) equals: 13.
	self assert: (matrix23 at: 3 at: 2) equals: 23.
	copyMatrix := matrix1 copy.
	self assert: matrix1 = copyMatrix.
	self assert: ((1 to: 4) allSatisfy: [ :i | matrix1 includes: i ])