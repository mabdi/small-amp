private
makeAssertsBasedOnMemory: aMemory
	| theLast |
	theLast := self findLastInMemory: aMemory.
	^ self makeAssertsBasedOnLast: theLast
	"(theLast isNil or: [ (self isEqualWith: theLast) not ])
		ifTrue: [ ^ self makeAssertsBasedOnLast: theLast ]
		ifFalse: [ ^ {} ]"