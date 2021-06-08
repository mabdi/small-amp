| repoName baseline load load_path |

baseline := Smalltalk os environment asDictionary at: #project_baseline ifAbsent: [ 'project_baseline missing' traceCr. Smalltalk exitFailure ].
load := Smalltalk os environment asDictionary at: #project_load ifAbsent: [ 'project_load missing, set to nil' traceCr. nil ].
load_path := Smalltalk os environment asDictionary at: #project_repository ifAbsent: [ 'project_repository missing' traceCr. Smalltalk exitFailure  ].

[ | b |
     b := Metacello new
        baseline: baseline;
        repository: 'tonel://', load_path;
        onUpgrade: [ :ex | ex useIncoming ];
        onConflictUseIncoming.
     load ifNotNil: [ b load: load ] ifNil: [ b load ]
] on: Warning do: [ :w | w resume ].
Smalltalk snapshot: true andQuit: true
