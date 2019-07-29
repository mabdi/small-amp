private
makeAssertsBasedOnMemory: aMemory
	| theLast |
	^ self makeAssertsBasedOnLast: nil
	"theLast := self findLastInMemory: aMemory."
	"(theLast isNil or: [ (self isEqualWith: theLast) not ])
		ifTrue: [ ^ self makeAssertsBasedOnLast: theLast ]
		ifFalse: [ ^ {} ]"