adding
addTemporaryVariables: anInt to: aMethod
	| rnd |
	rnd := GeneralHelper randomString.
	1 to: anInt do: [ :idx | aMethod body addTemporaryNamed: 'tmp_' ,rnd, idx asString ]