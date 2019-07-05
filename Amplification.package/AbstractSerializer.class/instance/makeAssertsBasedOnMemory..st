private
makeAssertsBasedOnMemory: aMemory
	| theLast |
	theLast := self findLastInMemory: aMemory.
	(theLast isNil or: [ (self isEqualWith: theLast) not ])
		ifTrue: [ ^ self makeAssertsBasedOnLast: theLast ]
		ifFalse: [ ^ {} ]