Class {
	#name : #SATonelMethodLocationFinder,
	#superclass : #SAAbstractMethodLocationFinder,
	#instVars : [
		'root'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SATonelMethodLocationFinder >> getPathOfClass: aClass [

	"Based on code in SmalltalkCI project"

	| pkg nonMetaClass fileName |
	pkg := (RPackageOrganizer default packageOf: aClass) packageName.
	nonMetaClass := (aClass respondsTo: #instanceSide)
		                ifTrue: [ aClass instanceSide ]
		                ifFalse: [ aClass theNonMetaClass ].
	fileName := root, '/', pkg , '/' , nonMetaClass name , '.class.st'.
	^ fileName
]

{ #category : #'as yet unclassified' }
SATonelMethodLocationFinder >> getTonelLocationInFileFor: aCompiledTest class: aClass [

	| tonelString offset methodStop filename |
	tonelString := self tonelStringFor: aClass.
	offset := self
		          lineNumberOffsetClass: aClass
		          method: aCompiledTest selector
		          in: tonelString.
	methodStop := self
		              lineNumberMethodStopClass: aClass
		              method: aCompiledTest selector
		              in: tonelString.
	filename := self getPathOfClass: aClass.
	^ { 
		  (#filename -> filename).
		  (#start -> offset).
		  (#stop -> methodStop) } asDictionary
]

{ #category : #'as yet unclassified' }
SATonelMethodLocationFinder >> lineNumberMethodStopClass: theClass method: theSelector in: tonelString [

	" From smalltalkCI "

	| inComment selector lineNumber methodFound |
	lineNumber := 0.
	inComment := false.
	methodFound := false.
	tonelString linesDo: [ :line | 
		lineNumber := lineNumber + 1.
		(line beginsWith: ']') ifTrue: [ 
			methodFound ifTrue: [ ^ lineNumber ] ].
		"(line beginsWith: $"" asString) ifTrue: [ inComment := inComment not ]."
		(inComment not and: [ line beginsWith: theClass name ]) ifTrue: [ "Start of method"
			selector := TonelParser new extractSelector:
				            ((line substrings: '>>') last copyWithout: $]).
			selector = theSelector ifTrue: [ methodFound := true ] ] ].
	^ -1
]

{ #category : #'as yet unclassified' }
SATonelMethodLocationFinder >> lineNumberOffsetClass: theClass method: theSelector in: tonelString [

	" From smalltalkCI "

	| inComment selector lineNumber |
	lineNumber := 0.
	inComment := false.
	tonelString linesDo: [ :line | 
		lineNumber := lineNumber + 1.
		"(line beginsWith: $"" asString) ifTrue: [ inComment := inComment not ]."
		(inComment not and: [ line beginsWith: theClass name ]) ifTrue: [ "Start of method"
			selector := TonelParser new extractSelector:
				            ((line substrings: '>>') last copyWithout: $]).
			selector = theSelector ifTrue: [ ^ lineNumber ] ] ].
	^ -1
]

{ #category : #'as yet unclassified' }
SATonelMethodLocationFinder >> locationFor: aCompiledTest [

	| tonelString offset methodStop filename aClass |
	aClass := aCompiledTest methodClass.
	tonelString := TonelWriter sourceCodeOf: aClass.
	offset := self
		          lineNumberOffsetClass: aClass
		          method: aCompiledTest selector
		          in: tonelString.
	methodStop := self
		              lineNumberMethodStopClass: aClass
		              method: aCompiledTest selector
		              in: tonelString.
	filename := self getPathOfClass: aClass.
	^ SAMethodLocation new filename: filename; startline: offset; endline: methodStop; yourself
]

{ #category : #accessing }
SATonelMethodLocationFinder >> root [

	^ root
]

{ #category : #accessing }
SATonelMethodLocationFinder >> root: anObject [

	root := anObject
]

{ #category : #'as yet unclassified' }
SATonelMethodLocationFinder >> tonelStringFor: aClass [
		^ TonelWriter sourceCodeOf: aClass
]
