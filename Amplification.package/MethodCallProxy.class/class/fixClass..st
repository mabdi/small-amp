as yet unclassified
fixClass: aClass
	aClass methodDict
		keysAndValuesDo: [ :selector :mtd | 
			mtd class = self
				ifTrue: [ aClass methodDict at: selector put: (mtd method) ] ]