private
canSerialize: anObject
	^ self supportingTypes
		anySatisfy: [ :c | 
			
			anObject isKindOf: c ]