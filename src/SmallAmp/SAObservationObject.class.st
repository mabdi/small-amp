Class {
	#name : #SAObservationObject,
	#superclass : #SAObservationValue,
	#category : #'SmallAmp-Model'
}

{ #category : #'as yet unclassified' }
SAObservationObject >> buildAssertions: aGenerator [
active
		ifFalse: [ ^ {} ].
	^ theClass smallAmpBuildAssertions: self by: aGenerator
]

{ #category : #adding }
SAObservationObject >> checkFlaky: anItem [
	self theValue
		keysDo: [ :key | 
			| v |
			v := self theValue at: key.
			v ifNotNil: [ v checkFlaky: (anItem theValue at: key ifAbsent: [ v isFlaky: true ]) ]
			 ]
]

{ #category : #testing }
SAObservationObject >> diff: anObject [
	| diff |
	diff := Dictionary new.
	self theValue
		keysDo: [ :key | 
			| v1 v2 |
			v1 := self theValue at: key.
			v2 := anObject theValue at: key ifAbsent: [ diff at: key put: v1.nil ].
			v1 isNotNil & v2 isNotNil
				ifTrue: [ (v1 isEquals: v2)
						ifFalse: [ diff at: key put: v1 ] ] ].
	diff ifEmpty: [ ^ nil ].
	^ diff
]

{ #category : #testing }
SAObservationObject >> isEquals: anObject [
	self theValue
		keysDo: [ :key | 
			| v1 v2 |
			v1 := self theValue at: key.
			v2 := anObject theValue at: key ifAbsent: [ ^ false ].
			v1 ifNil: [  v2 ifNotNil: [ ^ false ] ].
			v1 isNotNil & v2 isNotNil
				ifTrue: [ (v1 isEquals: v2)
						ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #accessing }
SAObservationObject >> theValue: anObject [
	super theValue: anObject.
	(self theValue reject: #isNil) do: [ :item | item parent: self ].
]

{ #category : #'as yet unclassified' }
SAObservationObject >> valueNode [
]
