tests
testUUIDGenerator
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