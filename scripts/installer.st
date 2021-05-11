"this file is used in SmallAmpPush CI flow"
| gitClone artifacts all_st package repo repoName |

Stdio stdout << 'Hi'; lf; flush.

gitClone := Smalltalk os environment asDictionary
		at: #GITHUB_WORKSPACE
		ifAbsent: [ ^ 1 ].
repoName := Smalltalk os environment asDictionary at: #reponame ifAbsent: [ ^ 1 ].
Stdio stdout << 'env is set'; lf; flush.
IceRepository registry
		detect: [ :r | r name = repoName ]
		ifNone: [ |r tmp|
   		   Stdio stdout << 'lets register the repo'; << gitClone; lf; flush.
		   r := IceRepositoryCreator new
				repository: nil;
				location: gitClone asFileReference.
                   r repository location: r locationToUse.
		   r repository pluginManager
			repositoryWillBeCreated: r repository.
		   Stdio stdout << '2'; lf; flush.
		   Stdio stdout << '2-name'; << r repository name ; lf; flush.		   				
  		   tmp := (r repository repositoryHandle lookupLocalBranch: r repository head name)
				targetId.
		   Stdio stdout << '2-target Id '; << tmp asString ; lf; flush.		   				
		   aLGitCommit := LGitCommit of: r repository repositoryHandle fromId: tmp.	
		   Stdio stdout << '2-commit '; << aLGitCommit asString ; lf; flush.
			Stdio stdout << 'aLGitCommit id: ';	<< aLGitCommit id hexString;
				<< ' name: '; << aLGitCommit author name;
				lf; flush.
			Stdio stdout << 'parents: ';	<< (aLGitCommit parents collect: [ :parent | parent id hexString ]);	
				lf; flush.
			Stdio stdout << ' message: ';	<< (aLGitCommit message);	
				lf; flush.				
		   r repository workingCopy initializePackagesFromRepository.
		   Stdio stdout << '3'; lf; flush.
		   r doEnsureProject.
		   Stdio stdout << '4'; lf; flush.
		   r repository pluginManager repositoryWasCreated: r repository.
		   Stdio stdout << '5'; lf; flush.
	r := r createRepository.
		   Stdio stdout << 'repo created'; lf; flush.
		   r register.
                   Stdio stdout << 'repo registerd'; lf; flush.
].
all_st := FileLocator imageDirectory childrenMatching: '*.st'.
(all_st reject: [ :a_st | a_st basename = 'installer.st' ]) do: [ :a_st | a_st asFileReference fileIn ].
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
Stdio stdout << 'changes has been updated successfully'; lf; flush.
repo := IceRepository registry detect: [ :r | r name = repoName ].
Stdio stdout << 'ready to write to disk'; lf; flush.
repo index updateDiskWorkingCopy: repo workingCopyDiff
