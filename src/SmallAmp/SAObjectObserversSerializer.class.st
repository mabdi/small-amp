Class {
	#name : #SAObjectObserversSerializer,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SAObjectObserversSerializer >> filterObserversOn: theObject [
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
		           method selector asString size > 2 and: [ 
			           (method selector indexOf: $:) = 0 ] ].
	methods := methods select: [ :m | m ast lastIsReturn ].
	methods := methods sort: [ :a :b | a selector <= b selector ].
	^ methods
]

{ #category : #accessing }
SAObjectObserversSerializer >> maxDepth [ 
	^ 3
]

{ #category : #accessing }
SAObjectObserversSerializer >> maxSuperClass [
	^ 2
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitBoolean: theObject atDepth: anInteger [
	^ self visitPrimitive: theObject  atDepth: anInteger  
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitByteString: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitChar: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitCollection: theObject atDepth: anInteger [
	| aCollection |
	anInteger > self maxDepth ifTrue: [ ^ nil ].
	aCollection := OrderedCollection new.
	theObject do: [ :item | 
		aCollection add:
			(item smallAmpAcceptSerializerVisitor: self atDepth: anInteger + 1) ].
	^ SAObservationCollection
		  newForClass: theObject class
		  values: aCollection atDepth: anInteger
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitNumber: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitObject: theObject atDepth: anInteger [
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
SAObjectObserversSerializer >> visitPrimitive: theObject atDepth: anInteger [
	anInteger > self maxDepth ifTrue: [ ^ nil ].
	^ SAObservationPrimitive
		  newForClass: theObject class
		  values: theObject
		atDepth: anInteger
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitUndefinedObject: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]
