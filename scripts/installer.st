| gitClone artifacts all_st package repo repoName |

'Script started' traceCr.
gitClone := Smalltalk os environment asDictionary at: #GITHUB_WORKSPACE ifAbsent: [ 'GITHUB_WORKSPACE missing' traceCr. Smalltalk exitFailure ].
repoName := Smalltalk os environment asDictionary at: #reponame ifAbsent: [ 'reponame missing' traceCr. Smalltalk exitFailure ].

all_st := FileLocator imageDirectory childrenMatching: '*.st'.
Stdio stdout << 'all_st: '; << (all_st collect: #asString); lf; flush.
(all_st reject: [ :a_st | a_st basename = 'installer.st' ]) do: [ :a_st | a_st asFileReference fileIn ].

Stdio stdout << 'File in done'; lf; flush.
(RPackageOrganizer default includesPackageNamed: 'SmallAmpFinalClasses') ifFalse: [ 'SmallAmpFinalClasses missing' traceCr. Smalltalk exitFailure ].

package := RPackageOrganizer default packageNamed: 'SmallAmpFinalClasses'.
package classes do: [ :aClass |
  aClass testSelectors do: [ :selector | 
      aClass superclass compile: (aClass lookupSelector: selector) sourceCode ]].

Stdio stdout << 'Classes installed'; lf; flush.      
repo := IceRepository registry detect: [ :r | r name = repoName ].
Stdio stdout << 'Repo:'; << repo asString; lf; flush.      
repo index updateDiskWorkingCopy: repo workingCopyDiff.
Stdio stdout << 'done'; lf; flush.      
Smalltalk snapshot: true andQuit: true
