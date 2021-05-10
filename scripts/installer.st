"this file is used in SmallAmpPush CI flow"
| gitClone artifacts all_st package repo |

gitClone := Smalltalk os environment asDictionary
		at: #GITHUB_WORKSPACE
		ifAbsent: [ ^ 1 ].
IceRepository registry
		detect: [ :r | r name = repoName ]
		ifNone: [ (IceRepositoryCreator new
				repository: nil;
				location: gitClone asFileReference;
				createRepository) register ].
artifacts := Smalltalk os environment asDictionary
		at: #SMALLAMPCI_ARTIFACTS
		ifAbsent: [ ^ 1 ].
all_st := (FileSystem disk referenceTo: (AbsolutePath with: artifacts)) childrenMatching: '*.st'.
all_st do: [:a_st | a_st asFileReference fileIn ].
(RPackageOrganizer default
		includesPackageNamed: 'SmallAmpFinalClasses')
		ifFalse: [ ^ 2 ].
package := RPackageOrganizer default
		packageNamed: self defaultFinalPackage.
package classes do: [ :aReadableClass |
  aReadableClass testSelectors
		do: [ :selector | 
			testClass
				compile: (aReadableClass lookupSelector: selector) sourceCode ]
].
repo := IceRepository registry
		detect:
			[ :r | r name = (Smalltalk os environment asDictionary at: #reponame) ].
repo index updateDiskWorkingCopy: repo workingCopyDiff
