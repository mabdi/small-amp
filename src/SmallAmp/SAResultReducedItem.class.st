Class {
	#name : #SAResultReducedItem,
	#superclass : #Object,
	#instVars : [
		'analysis',
		'reducer',
		'reducedClass',
		'presentationName'
	],
	#category : #'SmallAmp-Model'
}

{ #category : #accessing }
SAResultReducedItem >> analysis [
	^ analysis
]

{ #category : #accessing }
SAResultReducedItem >> analysis: anObject [
	analysis := anObject
]

{ #category : #'as yet unclassified' }
SAResultReducedItem >> markDownOn: stream [
	stream nextPutAll: '#TestMethods: '.
	stream nextPutAll: (reducedClass methods select: [:m | m hasPragmaNamed: SAASTHelper defaultPragma  ]) size asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: '#AllMutations: '.
	stream
		nextPutAll: analysis generalResult numberOfEvaluatedMutants asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: '#KilledMutants: '.
	stream
		nextPutAll: analysis generalResult numberOfKilledOrTerminatedMutants asString.
	stream nextPutAll: '<br>'.
	stream nextPutAll: 'Score: %'.
	stream nextPutAll: analysis generalResult mutationScore asString
]

{ #category : #'as yet unclassified' }
SAResultReducedItem >> presentationName [
	^ presentationName
]

{ #category : #'as yet unclassified' }
SAResultReducedItem >> presentationName: aName [
	presentationName:= aName
]

{ #category : #accessing }
SAResultReducedItem >> reducedClass [
	^ reducedClass
]

{ #category : #accessing }
SAResultReducedItem >> reducedClass: anObject [
	reducedClass := anObject
]

{ #category : #accessing }
SAResultReducedItem >> reducer [
	^ reducer
]

{ #category : #accessing }
SAResultReducedItem >> reducer: anObject [
	reducer := anObject
]
