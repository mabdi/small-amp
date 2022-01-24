| gitClone artifacts all_st package repo repoName diff |

'Script started' traceCr.
gitClone := Smalltalk os environment asDictionary at: #GITHUB_WORKSPACE ifAbsent: [ 'GITHUB_WORKSPACE missing' traceCr. Smalltalk exitFailure ].
repoName := Smalltalk os environment asDictionary at: #reponame ifAbsent: [ 'reponame missing' traceCr. Smalltalk exitFailure ].

repo := IceRepository registry detect: [ :r | r name = repoName ].
diff := repo workingCopyDiff.
Stdio stdout << 'Diff before import: '; << diff packages asString; lf; flush.

all_st := FileLocator imageDirectory childrenMatching: '*.st'.
Stdio stdout << 'all_st: '; << (all_st collect: #asString); lf; flush.
(all_st reject: [ :a_st | a_st basename = 'installer.st' ]) do: [ :a_st | a_st asFileReference fileIn ].

Stdio stdout << 'File in done'; lf; flush.
(RPackageOrganizer default includesPackageNamed: 'SmallAmpFinalClasses') ifFalse: [ 'SmallAmpFinalClasses missing' traceCr. Smalltalk exitFailure ].

package := RPackageOrganizer default packageNamed: 'SmallAmpFinalClasses'.
package classes do: [ :aClass |
  aClass testSelectors do: [ :selector | 
      Stdio stdout << 'Compiling:'; << aClass superclass name; << '>>'; << selector asString; << ', from: '; << aClass name; lf; flush.
      aClass superclass compile: (aClass lookupSelector: selector) sourceCode ]].

Stdio stdout << 'Classes installed'; lf; flush.      

diff := repo workingCopyDiff.
Stdio stdout << 'Diff after: '; << diff packages asString; lf; flush.

repo index updateDiskWorkingCopy: repo workingCopyDiff.
Stdio stdout << 'done'; lf; flush.      
Smalltalk snapshot: true andQuit: true
