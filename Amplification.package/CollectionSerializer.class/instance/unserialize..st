as yet unclassified
unserialize: aDic
	| theClass |
	theClass := aDic at: #class.
	self class subclasses
		detect: [ :s | 
			s instance supportingTypes
				contains:
					[ :q | q = theClass or: [ q allSubclasses contains: [ :w | w = theClass ] ] ] ]
		ifFound: [ :s | ^ s unserialize: (aDic at: #value) ]
		ifNone: [ ^ (aDic at: #class)
		withAll:
			((aDic at: #value)
				collect: [ :item | AbstractSerializer unserialize: item ]) ]