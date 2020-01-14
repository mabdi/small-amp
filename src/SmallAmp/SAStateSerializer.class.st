Class {
	#name : #SAStateSerializer,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SAStateSerializer >> filterObserversOn: theObject [
	| methods theClass |
	theClass := theObject class.
	methods := OrderedCollection new.
	self maxSuperClass timesRepeat: [ 
		theClass == Object ifFalse: [ 
			methods addAll: (theClass methodsInProtocol: #accessing)
				, (theClass methodsInProtocol: #testing)
				, (theClass methodsInProtocol: #evaluating). "the value method"
			theClass := theClass superclass ] ].
	methods := methods select: [ :method | 
		           method selector first isLetter and: [ 
			           (method selector indexOf: $:) = 0 ] ].
	methods := methods select: [ :m | m ast lastIsReturn ].
	methods := methods sort: [ :a :b | a selector <= b selector ].
	^ methods
]

{ #category : #accessing }
SAStateSerializer >> maxDepth [ 
	^ 3
]

{ #category : #accessing }
SAStateSerializer >> maxSuperClass [
	^ 2
]

{ #category : #visiting }
SAStateSerializer >> visitByteString: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitChar: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitCollection: theObject atDepth: anInteger [
	| aCollection |
	anInteger > self maxDepth
		ifTrue: [ ^ nil ].
	aCollection := OrderedCollection new.
	theObject
		do: [ :item | 
			| v |
			v := item
				smallAmpAcceptSerializerVisitor: self
				atDepth: anInteger + 1.
			v ifNotNil: [ aCollection add: v ]
			 ].
	^ SAObservationCollection
		newForClass: theObject class
		values: aCollection
		atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitFalse: theObject atDepth: anInteger [
	anInteger > self maxDepth ifTrue: [ ^ nil ].
	^ SAObservationFalse newAtDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitNumber: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitObject: theObject atDepth: anInteger [
	| result methods |
	anInteger > self maxDepth ifTrue: [ ^ nil ].
	result := Dictionary new.
	methods := self filterObserversOn: theObject .
	methods do: [ :l | 
		| retVal v |
		[ "anInteger = 0 ifTrue: [self halt]."
		retVal := theObject perform: l selector.
		retVal == theObject ifFalse: [ 
			v := retVal
				     smallAmpAcceptSerializerVisitor: self
				     atDepth: anInteger + 1 ] ]
			on: Error
			do: [ :ex | nil ].
		v ifNotNil: [ result at: l selector put: v ] ].
	^ SAObservationObject
		  newForClass: theObject class
		  values: result
		  atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitPrimitive: theObject atDepth: anInteger [
	anInteger > self maxDepth ifTrue: [ ^ nil ].
	^ SAObservationPrimitive
		  newForClass: theObject class
		  values: theObject
		atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitTrue: theObject atDepth: anInteger [
	anInteger > self maxDepth ifTrue: [ ^ nil ].
	^ SAObservationTrue
		  newAtDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitUndefinedObject: theObject atDepth: anInteger [
	anInteger > self maxDepth ifTrue: [ ^ nil ].
	^ SAObservationNil newAtDepth: anInteger
]
