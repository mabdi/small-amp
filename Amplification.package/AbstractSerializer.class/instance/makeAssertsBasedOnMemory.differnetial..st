private
makeAssertsBasedOnMemory: aMemory differnetial: aBoolean
	| theLast |
	theLast := nil.
	aBoolean ifTrue: [theLast := self findLastInMemory: aMemory].
	^ self makeAssertsBasedOnLast: theLast
	"(theLast isNil or: [ (self isEqualWith: theLast) not ])
		ifTrue: [ ^ self makeAssertsBasedOnLast: theLast ]
		ifFalse: [ ^ {} ]"