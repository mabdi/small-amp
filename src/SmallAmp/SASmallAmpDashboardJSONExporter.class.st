Class {
	#name : #SASmallAmpDashboardJSONExporter,
	#superclass : #Object,
	#instVars : [
		'saveTo',
		'root'
	],
	#category : #'SmallAmp-Helpers'
}

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

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> exportAll [

	| package result final mutations jsons theJson aClass |
	final := Dictionary new.
	mutations := OrderedCollection new.
	jsons := FileLocator imageDirectory childrenMatching: '*.json'.
	jsons do: [ :aJson | 
		aJson asFileReference readStreamDo: [ :readStream | 
			theJson := STONJSON fromStream: readStream ].
		(theJson includesKey: #amplifiedClass) ifTrue: [ 
			aClass := Smalltalk at: (theJson at: #amplifiedClass) asSymbol.
			"aClass := aClass superclass."
			mutations addAll: (theJson at: #newCovered).
			result := self exportClass: aClass smallampJson: theJson.
			result
				at: #results_json
				put: (self getJsonFileNameFor: aClass) basename.

			final at: aClass name put: result ] ].



	final at: #new_killed_mutations put: mutations asArray.
	self saveJson: final
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> exportClass: aClass smallampJson: smallampJson [

	| result |
	result := Dictionary new.
	result at: #name put: aClass name.
	result
		at: #amplified_class_address
		put: (smallampJson at: #amplifiedClass).
	result
		at: #amplified_tests
		put: (aClass testSelectors collect: [ :selector | 
				 selector asSymbol -> (self
					  amplifiedTestsFor: aClass >> selector asSymbol
					  json: smallampJson) ]) asDictionary.
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
	methodName := ((jsonObject at: #amplifiedMethods) at: test selector asString) 
		              at: #from.
	theClass := (methodName splitOn: '>>') first asSymbol .
	selector := (methodName splitOn: '>>') second allButFirst asSymbol.
	^ (Smalltalk at: theClass) >> selector
]

{ #category : #'as yet unclassified' }
SASmallAmpDashboardJSONExporter >> killedMutantsFor: test json: smallampJson [

	^ ((smallampJson at: #amplifiedMethods) at: test selector) at: #newCoverage
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
