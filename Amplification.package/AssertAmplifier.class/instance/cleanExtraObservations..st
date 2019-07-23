as yet unclassified
cleanExtraObservations: aMethod
	(aMethod body statements
		select: [ :item | self isObservationPoint: item ]) do: [ :item | aMethod body statements remove: item ]