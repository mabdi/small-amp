| tonel |
tonel := Smalltalk os environment asDictionary at: #SMALLAMP_TONEL ifAbsent: [ 'SMALLAMP_TONEL missing' traceCr. Smalltalk exitFailure ].


[ Metacello new
        baseline: 'SmallAmp';
        repository: 'gitlocal://', tonel ,'/src';
        onUpgrade: [ :ex | ex useIncoming ];
        onConflictUseIncoming;
        load: 'core' 
] on: Warning do: [ :w | w resume ].
Smalltalk snapshot: true andQuit: true
