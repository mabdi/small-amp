running
findPattern
	^ {'self deny: ``@aBooleanOrBlock' . 'self deny: ``@aBooleanOrBlock description: ``@aStringOrBlock'.
	'self deny: ``@aBooleanOrBlock description: ``@aStringOrBlock resumable: ``@resumableBoolean'.
	'self shouldnt: ``@aBooleanOrBlock' . 'self shouldnt: ``@aBooleanOrBlock description: ``@aStringOrBlock'}