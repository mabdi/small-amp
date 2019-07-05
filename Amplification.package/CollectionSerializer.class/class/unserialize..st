as yet unclassified
unserialize: dictionary
	^ (dictionary at: #class)
		withAll:
			((dictionary at: #value)
				collect: [ :item | SerializerFactory unserialize: item ])