adding
addTemporaryVariables: anInt to: aMethod
	1 to: anInt do: [ :idx | aMethod body addTemporaryNamed: 'tmp', idx asString  ]