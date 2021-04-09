Extension { #name : #IceRepository }

{ #category : #'*SmallAmp' }
IceRepository class >> latestCommitIdFor: repoName [
	self registry
		detect: [ :r | r name = repoName ]
		ifFound: [ :r | ^ r branch commits first shortId ]
		ifNone: [ 'latestCommitIdFor: repo not found.' traceCr ].
	^ 'NA'
]

{ #category : #'*SmallAmp' }
IceRepository class >> pullRepoNamed: repoName [
	self registry
		detect: [ :r | r name = repoName ]
		ifFound: [ :r | r pullFrom: r remotes first ]
		ifNone: [ self error: 'repo not found.' ]
]
