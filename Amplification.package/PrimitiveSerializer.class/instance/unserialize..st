as yet unclassified
unserialize: aDic
	"| val |
	val := aDic at: #value.
	(aDic at: #class) = ByteString
		ifTrue: [ val := '''' , val , '''' ].
	^ RBParser parseExpression: val"

	| theClass |
	theClass := aDic at: #class.
	self class subclasses
		detect: [ :s | 
			s instance supportingTypes
				contains:
					[ :q | q = theClass or: [ q allSubclasses contains: [ :w | w = theClass ] ] ] ]
		ifFound: [ :s | ^ s unserialize: (aDic at: #value) ]