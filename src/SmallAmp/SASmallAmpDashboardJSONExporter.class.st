Class {
	#name : #SASmallAmpDashboardJSONExporter,
	#superclass : #Object,
	#instVars : [
		'saveTo',
		'root',
		'commitHash',
		'stfilesSaveTo',
		'project'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #adding }
SASmallAmpDashboardJSONExporter >> addAmplified_classesTo: aDictionary [

	| classes mutations jsons theJson aClass result |
	classes := Dictionary new.
	mutations := OrderedCollection new.
	jsons := FileLocator imageDirectory childrenMatching: '*.json'.
	jsons do: [ :aJson | 
		aJson asFileReference readStreamDo: [ :readStream | 
			theJson := STONJSON fromStream: readStream ].
		(theJson includesKey: #amplifiedClass) ifTrue: [ 
			aClass := (Smalltalk at: (theJson at: #amplifiedClass) asSymbol)
				          superclass.

			mutations addAll: (theJson at: #newCovered).
			"aClass := aClass superclass."
			result := self
				          exportClass: aClass
				          smallampJson: theJson
				          current:
				          (classes at: aClass name ifAbsent: [ nil ]).
			self moveClass: aClass.
			result at: #results_json put: aJson asFileReference basename.

			classes at: aClass name put: result ] ].

	aDictionary at: #amplified_classes put: classes values asArray.
	aDictionary at: #new_killed_mutations put: mutations asArray
]

{ #category : #adding }
SASmallAmpDashboardJSONExporter >> addCommonMetadataTo: aDictionary [

	|  timestamp |
	timestamp := DateAndTime now asUnixTime.
	aDictionary at: #timestamp put: timestamp.
	aDictionary at: #head_commit_id put: self commitHash 
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> amplifiedTestsFor: test json: smallampJson [

	| location lfinder original_test original_test_location killed_mutants |
	lfinder := self getLocationFinder root: root.
	location := lfinder locationFor: test.
	original_test := self getOriginalTestFor: test json: smallampJson.
	original_test_location := lfinder locationFor: original_test.
	killed_mutants := self killedMutantsFor: test json: smallampJson.
	^ { 
		  (#testname -> test selector).
		  (#test_fullname -> test name).
		  (#filename -> location filename).
		  (#fromline -> location startline).
		  (#toline -> location endline).
		  (#new_coverage -> killed_mutants asArray).
		  (#original_test -> { 
			   (#testname -> original_test selector).
			   (#test_fullname -> original_test name).
			   (#filename -> original_test_location filename).
			   (#fromline -> original_test_location startline).
			   (#toline -> original_test_location endline) } asDictionary) }
		  asDictionary
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> commitHash [

	^ commitHash
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> commitHash: anObject [

	commitHash := anObject
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> exportAll [

	| final |
	final := Dictionary new.
	self addCommonMetadataTo: final.
	self addAmplified_classesTo: final.
	"MutalkCI new
		project: project;
		mutateAll."
	self saveJson: final
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> exportClass: aClass smallampJson: smallampJson [

	^ self
		  exportClass: aClass
		  smallampJson: smallampJson
		  current: nil
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> exportClass: aClass smallampJson: smallampJson current: anObject [

	| aCollection result lfinder amplifiedMethods |
	anObject
		ifNil: [ 
			result := Dictionary new.
			result at: #name put: aClass name.
			lfinder := self getLocationFinder
				           root: root;
				           yourself.
			result
				at: #amplified_class_address
				put: (lfinder getPathOfClass: aClass).
			aCollection := OrderedCollection new ]
		ifNotNil: [ 
			result := anObject.
			aCollection := (result at: #amplified_tests) asOrderedCollection ].

	amplifiedMethods := ((smallampJson at: #amplifiedMethods) collect: [ 
		                    :m | m at: #selector_pretty ]) reject: #isEmpty.
	aCollection addAll: (amplifiedMethods collect: [ :selector | 
			 self
				 amplifiedTestsFor: aClass >> selector asSymbol
				 json: smallampJson ]).
	result at: #amplified_tests put: aCollection asArray.

	^ result
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> getJsonFileNameFor: aClass [

	^ FileLocator imageDirectory / (aClass name , '.json')
		
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> getJsonFor: aClass [

	(self getJsonFileNameFor: aClass)
		asFileReference readStreamDo: [ :readStream | 
		^ STONJSON fromStream: readStream ]
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> getLocationFinder [
self flag: #todo. "I only consider tonel at the moment. it should check the repo and detect tonel or filetree"
	^ SATonelMethodLocationFinder new
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> getLocationInFileFor: aCompiledTest class: aClass [

	^ self getLocationFinder
		  root: root;
		  yourself
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> getOriginalTestFor: test json: jsonObject [

	| methodName theClass selector |
	methodName := ((jsonObject at: #amplifiedMethods) detect: [ :m | 
		   (m at: #selector_pretty) = test selector asString ]
		               ) at: #from.
	theClass := (methodName splitOn: '>>') first asSymbol.
	selector := (methodName splitOn: '>>') second allButFirst asSymbol.
	^ (Smalltalk at: theClass) >> selector
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> killedMutantsFor: test json: smallampJson [

	^ ((smallampJson at: #amplifiedMethods) detect: [ :m | (m at: #selector_pretty) = test selector ] ) at:
		  #newCoverage
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> moveClass: aClass [

	| lfinder |
	lfinder := self getLocationFinder
		           root: root;
		           yourself.
	lfinder moveClass: aClass to: self stfilesSaveTo
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> moveClass: aClass smallampJson: smallampJson [

	| lfinder amplified_class |
	lfinder := self getLocationFinder
		           root: root;
		           yourself.
	amplified_class := Smalltalk at:
		                   (smallampJson at: #amplifiedClass) asSymbol.
	lfinder moveClass: amplified_class to: self stfilesSaveTo
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> newKilledMutants: classes [

	| jsonObj mutants |
	mutants := (classes flatCollect: [ :cls | 
		            jsonObj := self getJsonFileNameFor: cls.
		            (jsonObj at: #newCovered) ]) asArray.
	^ mutants
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> project [

	^ project
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> project: anObject [

	project := anObject
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> root [

	^ root
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> root: anObject [

	root := anObject
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> saveJson: jsonObj [

	| str |
	str := STONJSON toStringPretty: jsonObj.
	(FileLocator imageDirectory / self saveTo) exists ifTrue: [ 
		(FileLocator imageDirectory / self saveTo) delete ].
	(FileLocator imageDirectory / self saveTo) writeStream
		nextPutAll: str;
		close
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> saveTo [

	^ saveTo
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> saveTo: anObject [

	saveTo := anObject
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> stfilesSaveTo [

	^ stfilesSaveTo
]

{ #category : #accessing }
SASmallAmpDashboardJSONExporter >> stfilesSaveTo: anObject [

	stfilesSaveTo := anObject
]
