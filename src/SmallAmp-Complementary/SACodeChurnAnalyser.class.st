Class {
	#name : #SACodeChurnAnalyser,
	#superclass : #Object,
	#category : #'SmallAmp-Complementary'
}

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> codeChurnFileTree: classFolder repoName: aGithubProjectName [
	| location cmd history adds removes changes filename ch |
	location := IceRepository registry
		detect: [ :pr | pr name = aGithubProjectName ]
		ifFound: [ :pr | pr location ]
		ifNone: [ self error: 'churn error: project name is not in iceberg' ].
	history := self
		runGitLogOn: classFolder
		path: location asFileReference pathString.
	adds := 0.
	removes := 0.
	history := (history splitOn: Character lf) reject: #isEmpty.
	history ifEmpty: [ ^ 0 ].
	history
		do: [ :line | 
			changes := self
				runGitShowOn: classFolder
				line: line
				path: location asFileReference pathString.
			changes := (changes splitOn: Character lf) reject: #isEmpty.
			changes
				do: [ :change | 
					ch := change splitOn: Character tab.
					adds := adds + (ch at: 1) asInteger.
					removes := removes + (ch at: 1) asInteger ] ]. 
	^ (adds + removes) / history size
]

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> codeChurnForClass: aClass [
	(self repoForClass: aClass) properties fileFormat
		= IceLibgitTonelWriter
		ifTrue: [ ^ self codeChurnForTonelClass: aClass ].
	(self repoForClass: aClass) properties fileFormat
		= IceLibgitFiletreeWriter
		ifTrue: [ ^ self codeChurnForFileTreeClass: aClass ].
	self error: 'unknown file format'
]

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> codeChurnForFileTreeClass: aClass [
	| package repoName base classFolder |
	package := (IceRepository registry flatCollect: #loadedPackages)
		detect: [ :p | p name = aClass package name ]
		ifNone: [ self error: 'not found' ].
	repoName := package repository name.
	base := package repository subdirectory.
	base ifNotEmpty: [ base := base , '/' ].
	classFolder := base , package package , '.package/' , aClass name , '.class/'.
	^ self codeChurnFileTree: classFolder repoName: repoName 
]

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> codeChurnForTonelClass: aClass [
	| package repoName base filename |
	package := (IceRepository registry flatCollect: #loadedPackages)
		detect: [ :p | p name = aClass package name ]
		ifNone: [ self error: 'not found' ].
	repoName := package repository name.
	base := package repository subdirectory.
	base ifNotEmpty: [ base := base , '/' ].
	filename := base , package package , '/' , aClass name , '.class.st'.
	^ self codeChurnTonel: filename repoName: repoName 
]

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> codeChurnTonel: filename repoName: aGithubProjectName [
	| location history adds removes changes ch |
	location := IceRepository registry
		detect: [ :pr | pr name = aGithubProjectName ]
		ifFound: [ :pr | pr location ]
		ifNone: [ self error: 'churn error: project name is not in iceberg' ].
	history := self
		runGitLogOn: filename
		path: location asFileReference pathString.
	adds := 0.
	removes := 0.
	history := (history splitOn: Character lf) reject: #isEmpty.
	history ifEmpty: [ ^ 0 ].
	history
		do: [ :line | 
			changes := self
				runGitShowOn: filename
				line: line
				path: location asFileReference pathString.
			changes := (changes splitOn: Character lf) reject: #isEmpty.
			
			changes do:[ :change | ch  := change splitOn: Character tab.
					adds := adds + (ch at: 1) asInteger.
					removes := removes + (ch at: 1) asInteger ] ].
	^ (adds + removes) / history size
]

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> repoForClass: aClass [
	^ ((IceRepository registry flatCollect: #loadedPackages)
		detect: [ :p | p name = aClass package name ]
		ifNone: [ self error: 'not found' ])
	repository
]

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> runGitLogOn: filename path: directory [
	| cmd |
	cmd := '' join: {'(cd '. directory. ' && git log --format="%H" '. filename
		. ')'}.
	^ OSPlatform current resultOfCommand: cmd
]

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> runGitShowOn: filename line: line path: path [
	| cmd |
	cmd := ''
		join:
			{'(cd '.
			path.
			' && git show --numstat --pretty="" '.
			line.
			' | grep '.
			(filename splitOn: $/) last.
			')'}.
	^ OSPlatform current resultOfCommand: cmd
]
