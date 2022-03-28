| repoName baseline load load_path gitClone commitId env_GITHUB_REPOSITORY env_GITHUB_REF_NAME repo |

baseline := Smalltalk os environment asDictionary at: #project_baseline ifAbsent: [ 'project_baseline missing' traceCr. Smalltalk exitFailure ].
load := Smalltalk os environment asDictionary at: #project_load ifAbsent: [ 'project_load missing, set to nil' traceCr. nil ].
load ifNotNil: [load ifEmpty: [load := nil]].

load_path := Smalltalk os environment asDictionary at: #project_repository ifAbsent: [ 'project_repository missing' traceCr. Smalltalk exitFailure  ].

gitClone := Smalltalk os environment asDictionary at: #GITHUB_WORKSPACE ifAbsent: [ 'GITHUB_WORKSPACE missing' traceCr. Smalltalk exitFailure ].
env_GITHUB_REPOSITORY := Smalltalk os environment asDictionary at: #GITHUB_REPOSITORY ifAbsent: [ 'GITHUB_REPOSITORY missing' traceCr. Smalltalk exitFailure ].
env_GITHUB_REF_NAME := Smalltalk os environment asDictionary at: #GITHUB_REF_NAME ifAbsent: [ 'GITHUB_REF_NAME missing' traceCr. Smalltalk exitFailure ].
repoName := Smalltalk os environment asDictionary at: #reponame ifAbsent: [ 'reponame missing' traceCr. Smalltalk exitFailure ].

[ | b |
     b := Metacello new
        baseline: baseline;
        repository: 'gitlocal://', load_path;
        onUpgrade: [ :ex | ex useIncoming ];
        onConflictUseIncoming.
     load ifNotNil: [ b load: load ] ifNil: [ b load ]
] on: Warning do: [ :w | w resume ].

'List all installed repos:' traceCr.

(IceRepository registry collect: #name) asString traceCr.

repo := (IceRepository registry detect: [ :n | n name = repoName ]).
commitId := repo branch commit shortId.

('Project registered in Iceberg ', commitId asString) traceCr.

Smalltalk snapshot: true andQuit: true
