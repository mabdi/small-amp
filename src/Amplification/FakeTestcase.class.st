Class {
	#name : #FakeTestcase,
	#superclass : #TestCase,
	#instVars : [
		'someVariable',
		'someString'
	],
	#category : #'Amplification-TestsClasses'
}

{ #category : #running }
FakeTestcase >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	someVariable := 1.
	someString := 'abcd'
	
]

{ #category : #tests }
FakeTestcase >> testArray2D [
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
]

{ #category : #tests }
FakeTestcase >> testAssertCloseTo [
	self assert: 10 closeTo: 10.
	self assert: 10.00001 closeTo: 10.
	self assert: 29.000004 closeTo: 29.
]

{ #category : #tests }
FakeTestcase >> testAssertCollectionHasSameElements [
   | q |
	q := SharedQueue new.
	self should: [ q nextOrNil isNil ].
	self assert: q atEnd.
	q nextPut: 5.
	self assertCollection: q contents hasSameElements: #(5).
	self should: [ q nextOrNil = 5 ].
	self should: [ q nextOrNil isNil ].
	self assert: q atEnd
]

{ #category : #tests }
FakeTestcase >> testAssertEquals [
	| array |
	array := #[1 2 3 4 5 6 7 8 9 10 11 1 2 3 4 5 6 7 8 0 0].
	self assert: (array indexOf: 1 startingAt: 10) equals: 12.
	self assert: (array indexOf: 17 startingAt: 10) equals: 0
]

{ #category : #tests }
FakeTestcase >> testDeny [
	
	| heap |
	heap := Heap new.
	self assert: heap size equals: 0.
	heap add: 3.
	self assert: heap size equals: 1.
	self deny: heap isEmpty.
	self assert: heap first equals: 3.
	heap add: 2.
	self assert: heap size equals: 2.
	self assert: heap first equals: 2
]

{ #category : #tests }
FakeTestcase >> testDenyEquals [
	
	| c1 c2 c3 |
	c1 := #(1 2) asOrderedCollection.
	self assert: c1 capacity equals: 2.
	c2 := OrderedCollection new: 10.
	c2 add: 3.
	self assert: c2 capacity equals: 10.
	c3 := OrderedCollection new.
	self deny: c3 capacity equals: 0
]

{ #category : #tests }
FakeTestcase >> testFallbackReplaceFromToWithForString [
	| testString byteArray stringByteSize |
	testString := 'Test string'.
	stringByteSize := 'Test string' byteSize.
	byteArray := ByteArray new: stringByteSize.
	self
		shouldnt: [ byteArray
				replaceFrom: 1
				to: stringByteSize
				with: testString
				startingAt: 1 ]
		raise: Exception
		description: 'Primitive 105 should be optional for ByteArray'
]

{ #category : #tests }
FakeTestcase >> testHex [
	self assert: #[122 43 213 7] hex = '7a2bd507'.
	self
		assert:
			#[151 193 242 221 249 32 153 72 179 41 49 154 48 193 99 134] hex
				= '97c1f2ddf9209948b329319a30c16386'.
	self assert: (ByteArray readHexFrom: '7A2BD507') = #[122 43 213 7].
	self assert: (ByteArray readHexFrom: '7a2bd507') = #[122 43 213 7]
]

{ #category : #tests }
FakeTestcase >> testShouldNotTakeMoreThan [
	|g| g:=UUIDGenerator new.self
		should: [ 100000 timesRepeat: [ g next ] ]
		notTakeMoreThan: 1 second
]

{ #category : #tests }
FakeTestcase >> testShouldRaise [
	self assert: (#(1 3 5 7 11 15 23) findBinary: [ :arg | 1 - arg ]) = 1.
	self
		assert: (#(1 3 5 7 11 15 23) findBinary: [ :arg | 23 - arg ]) = 23.
	self
		assert: (#(1 3 5 7 11 15 23) findBinary: [ :arg | 11 - arg ]) = 11.
	self
		should: [ #(1 3 5 7 11 15 23) findBinary: [ :arg | 8 - arg ] ]
		raise: NotFound
]

{ #category : #tests }
FakeTestcase >> testShouldntRaise [
	| file |
	file := File named: 'asdqhdjhakjhdkjasdjkhbasdjhbasdjhb.fake'.
	self shouldnt: [ file checkDoesNotExist ] raise: Error
]

{ #category : #tests }
FakeTestcase >> testUUIDGenerator [
	| generator previousUuid uuid generator1 generator2 uuid1 uuid2 time1 time2 count uuids timeFromUUID |
	generator := UUIDGenerator new.
	previousUuid := generator next.
	"the internal counter inside generator will rollover at 16r10000,
	the least significant 10th byte rolls over every 16r100,
	the internal counter starts at a random value"
	2 * 16r10000
		timesRepeat: [ uuid := generator next.
			"same generator, consequetive counters (take roll-over into account)"
			self
				assert: ((previousUuid at: 10) + 1) \\ 256
				equals: (uuid at: 10).
			previousUuid := uuid ].
	self assert: UUIDGenerator default equals: UUIDGenerator default.
	self deny: UUIDGenerator next isNilUUID.
	uuid := generator next.
	self assert: (uuid isKindOf: UUID).
	self deny: uuid isNilUUID.
	generator1 := UUIDGenerator new.
	generator2 := UUIDGenerator new.
	uuid1 := generator1 next.
	uuid2 := generator2 next.
	"different UUIDs"
	self deny: uuid1 = uuid2.
	"different generators, different node id"
	self
		deny: uuid1 reverse readStream uint32 = uuid2 reverse readStream uint32.
	"same generators, similar clock, within 100 milliseconds (stored time is in microseconds)"
	timeFromUUID := [ :quuid | 
	| bytes in |
	in := quuid readStream.
	bytes := ByteArray
		streamContents: [ :out | 8 timesRepeat: [ out nextPut: in next ] ].
	^ bytes reverse asInteger ].
	time1 := timeFromUUID value: uuid1.
	time2 := timeFromUUID value: uuid2.
	self assert: (time2 - time1) abs < (100 * 1000).
	uuid1 := generator next.
	uuid2 := generator next.
	"different UUIDs"
	self deny: uuid1 = uuid2.
	"same generator, same node id"
	self
		assert: uuid1 reverse readStream uint32
		equals: uuid2 reverse readStream uint32.
	"same generator, consecutive counters (take roll-over into account)"
	self assert: ((uuid1 at: 10) + 1) \\ 256 equals: (uuid2 at: 10).
	"same generators, similar clock, within 100 milliseconds (stored time is in microseconds)"
	time1 := timeFromUUID value: uuid1.
	time2 := timeFromUUID value: uuid2.
	self assert: (time2 - time1) abs < (100 * 1000).
	count := 100000.
	uuids := Set new: count.
	count timesRepeat: [ uuids add: generator next ].
	self assert: uuids size equals: count
]
