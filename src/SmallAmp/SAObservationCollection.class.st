Class {
	#name : #SAObservationCollection,
	#superclass : #SAObservationObject,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationCollection >> buildAssertions: aGenerator [
active
		ifFalse: [ ^ {} ].
	^ aGenerator buildAssertionsCollectionObservation: self
]

{ #category : #adding }
SAObservationCollection >> checkFlaky: anItem [
	self theValue
		doWithIndex: [ :item :index | 
			| v |
			v := self theValue at: index.
			anItem theValue size < index
				ifTrue: [ v := nil ].
			v ifNotNil: [ v checkFlaky: (anItem theValue at: index) ] ]
]

{ #category : #testing }
SAObservationCollection >> diff: anObject [
	| diff |
	diff := Dictionary new.
	self theValue
		doWithIndex: [ :item :index | 
			| v1 v2 |
			v1 := self theValue at: index.
			v2 := anObject theValue at: index ifAbsent: [ diff at: index put: v1.nil ].
			v1 isNotNil & v2 isNotNil
				ifTrue: [ (v1 isEquals: v2)
						ifTrue: [ diff at: index put: v1 ] ] ].
	diff ifEmpty: [ ^ nil ].
	^ diff
]

{ #category : #testing }
SAObservationCollection >> isEquals: anObject [
	self theValue
		doWithIndex: [ :item :index | 
	 
			| v1 v2 |
			v1 := self theValue at: index.
			v2 := anObject theValue at: index ifAbsent: [ ^ false ].
			v1 ifNil: [ v2 ifNotNil: [ ^ false ] ].
			v1 isNotNil & v2 isNotNil
				ifTrue: [ (v1 isEquals: v2)
						ifFalse: [ ^ false ] ] ].
	^ true
]
