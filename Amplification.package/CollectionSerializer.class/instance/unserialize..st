as yet unclassified
unserialize: aDic
	^ (aDic at: #class)
		withAll:
			((aDic at: #value)
				collect: [ :item | AbstractSerializer unserialize: item ])