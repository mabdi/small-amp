adding
addTemporaryVariables: anInt to: aMethod
	tmpVariables := (1 to: anInt)
		collect: [ :idx | 'tmp_' , GeneralHelper randomString , idx asString ].
	EvalLog at: #temps put: anInt.
	tmpVariables do: [ :tvar | aMethod body addTemporaryNamed: tvar ]