| repoName baseline load load_path gitClone commitId |

baseline := Smalltalk os environment asDictionary at: #project_baseline ifAbsent: [ 'project_baseline missing' traceCr. Smalltalk exitFailure ].
load := Smalltalk os environment asDictionary at: #project_load ifAbsent: [ 'project_load missing, set to nil' traceCr. nil ].
load_path := Smalltalk os environment asDictionary at: #project_repository ifAbsent: [ 'project_repository missing' traceCr. Smalltalk exitFailure  ].

gitClone := Smalltalk os environment asDictionary at: #GITHUB_WORKSPACE ifAbsent: [ 'GITHUB_WORKSPACE missing' traceCr. Smalltalk exitFailure ].
env_GITHUB_REPOSITORY := Smalltalk os environment asDictionary at: #GITHUB_REPOSITORY ifAbsent: [ 'GITHUB_REPOSITORY missing' traceCr. Smalltalk exitFailure ].
env_GITHUB_REF_NAME := Smalltalk os environment asDictionary at: #GITHUB_REF_NAME ifAbsent: [ 'GITHUB_REF_NAME missing' traceCr. Smalltalk exitFailure ].
repoName := Smalltalk os environment asDictionary at: #reponame ifAbsent: [ 'reponame missing' traceCr. Smalltalk exitFailure ].

[ | b |
     b := Metacello new
        baseline: baseline;
        repository: 'github://', env_GITHUB_REPOSITORY , ':', env_GITHUB_REF_NAME;
        onUpgrade: [ :ex | ex useIncoming ];
        onConflictUseIncoming.
     load ifNotNil: [ b load: load ] ifNil: [ b load ]
] on: Warning do: [ :w | w resume ].

'Metacelo finished. lets register in Iceberg' traceCr.

IceRepository registry
		detect: [ :r | r name = repoName ]
		ifNone: [ |r tmp|
		   'Project is not registered. I try to register it.' traceCr.
		   r := IceRepositoryCreator new
				repository: nil;
				location: gitClone asFileReference.
   	           r := r createRepository.
		   r register.
		   ].
commitId := (IceRepository registry detect: [ :n | n name = repoName ]) branch commit shortId.

('Project registered in Iceberg ', commitId asString) traceCr.

Smalltalk snapshot: true andQuit: true
