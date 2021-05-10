"this file is used in SmallAmpPush CI flow"
| gitClone artifacts all_st package repo repoName |

gitClone := Smalltalk os environment asDictionary
		at: #GITHUB_WORKSPACE
		ifAbsent: [ ^ 1 ].
repoName := Smalltalk os environment asDictionary at: #reponame ifAbsent: [ ^ 1 ].
IceRepository registry
		detect: [ :r | r name = repoName ]
		ifNone: [ (IceRepositoryCreator new
				repository: nil;
				location: gitClone asFileReference;
				createRepository) register ].
all_st := FileLocator imageDirectory childrenMatching: '*.st'.
all_st do: [:a_st | a_st asFileReference fileIn ].
(RPackageOrganizer default
		includesPackageNamed: 'SmallAmpFinalClasses')
		ifFalse: [ ^ 2 ].
package := RPackageOrganizer default packageNamed: 'SmallAmpFinalClasses'.
package classes do: [ :aClass |
  aClass testSelectors
		do: [ :selector | 
			aClass superclass
				compile: (aClass lookupSelector: selector) sourceCode ]
].
repo := IceRepository registry detect: [ :r | r name = repoName ].
repo createBranch: 'smallamp-run-' , (Smalltalk os environment asDictionary at: #run_number).
repo index updateDiskWorkingCopy: repo workingCopyDiff
