| gitClone artifacts all_st package repo repoName diff toCommit visitor commitText test |

'Script started' traceCr.
gitClone := Smalltalk os environment asDictionary at: #GITHUB_WORKSPACE ifAbsent: [ 'GITHUB_WORKSPACE missing' traceCr. Smalltalk exitFailure ].
repoName := Smalltalk os environment asDictionary at: #reponame ifAbsent: [ 'reponame missing' traceCr. Smalltalk exitFailure ].

toCommit:= OrderedCollection new.
repo := IceRepository registry detect: [ :r | r name = repoName ].
Stdio stdout << 'Repo found. Its loaded from: '; << repo location asAbsolute  pathString; lf; flush.
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
      aClass superclass compile: (aClass lookupSelector: selector) sourceCode.
	    test := aClass superclass >> selector.
	    toCommit := OrderedCollection new.
	    toCommit add: test.
	    visitor := SANewChangesDiffVisitor new methodsToCommit: toCommit.
	    diff := repo workingCopyDiff.
	    diff accept: visitor.
	    diff := diff copyWithOnly: visitor newTree.
	    commitText := 'A new test method is added: ' , test name.
	    commitText := test ast hasComments ifTrue: [ 
		              commitText := '{1}
{2}' format: { 
				                            commitText.
				                            test ast comments first contents } ].
      repo commitChanges: diff withMessage: commitText.
  ]].

Stdio stdout << 'done'; lf; flush.      
Smalltalk snapshot: true andQuit: true
