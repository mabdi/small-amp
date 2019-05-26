as yet unclassified
doYourJob: aMethodSrc
	| results aMethod |
	results := OrderedCollection new.
	aMethod := RBParser parseMethod: aMethodSrc.
	self visitNode: aMethod.
	mappings do: [ :map | 
		results addAll: (self replaceMappings: map on: aMethod)
		
		 ].
	^ results