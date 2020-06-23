Class {
	#name : #SACodeChurnAnalyser,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> codeChurn: filename repoName: aGithubProjectName [
	| location cmd history adds removes changes |
	location := IceRepository registry
		detect: [ :pr | pr name = aGithubProjectName ]
		ifFound: [ :pr | pr location ]
		ifNone: [ self error: 'churn error: project name is not in iceberg' ].
	cmd := '(cd ' , location asFileReference pathString
		, ' && git log --format="%H" ' , filename , ')'.
	history := OSPlatform current resultOfCommand: cmd.
	adds := 0.
	removes := 0.
	history := (history splitOn: Character lf) reject: #isEmpty.
	history ifEmpty: [ ^ 0 ].
	history
		do: [ :line | 
			cmd := '(cd ' , location asFileReference pathString
				, ' && git show --numstat --pretty="" ' , line , ' | grep '
				, filename , ')'.
			changes := OSPlatform current resultOfCommand: cmd.
			changes := changes splitOn: Character tab.
			adds := adds + (changes at: 1) asInteger.
			removes := removes + (changes at: 1) asInteger ].
	^ (adds + removes) / history size 
]

{ #category : #'as yet unclassified' }
SACodeChurnAnalyser >> codeChurnForClass: aClass [
	| package repoName base filename |
	[ package := (IceRepository registry flatCollect: #loadedPackages)
		detect: [ :p | p name = aClass package name ]
		ifNone: [ self error: 'not found' ].
	repoName := package repository name.
	base := package repository subdirectory.
	base ifNotEmpty: [ base := base , '/' ].
	filename := base , package package , '/' , aClass name , '.class.st'.
	^ self codeChurn: filename repoName: repoName ]
		on: Error
		do: [ ^ -1 ]
]
