private
canUnSerialize: aDic
	"^ self myTag = (aDic at: #type)"
	^ self supportingTypes
		anySatisfy: [ :c | ((aDic at: #class) = c) or: [(aDic at: #class) allSuperclasses includes: c] ]