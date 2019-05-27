as yet unclassified
renameTempVars: anStr
	^ anStr
		copyWithRegex: 'tmp_([a-z0-9A-Z]+)\d+'
		matchesTranslatedUsing: [ :each | 'tmp' , (each allButFirst: 14) ]