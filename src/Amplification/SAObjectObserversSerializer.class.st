Class {
	#name : #SAObjectObserversSerializer,
	#superclass : #Object,
	#category : #'Amplification-Experiment'
}

{ #category : #accessing }
SAObjectObserversSerializer >> maxDepth [ 
	^ 3
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
		item smallAmpAcceptSerializerVisitor: self atDepth: anInteger + 1 ].
	^ SAObservationItem newForCollection: theObject values: aCollection
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitNumber: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitObject: theObject atDepth: anInteger [
	| result methods |
	result := Dictionary new.
	methods := (theObject class methodsInProtocol: #accessing)
	           , (theObject class methodsInProtocol: #testing).
	methods := methods select: [ :m | m ast lastIsReturn ].
	((methods sort: [ :a :b | a selector <= b selector ]) select: [ 
		 :method | (method selector indexOf: $:) = 0 ]) do: [ :l | 
		| v |
		[ 
		v := (theObject perform: l selector)
			     smallAmpAcceptSerializerVisitor: self
			     atDepth: anInteger + 1 ]
			on: Error
			do: [ :ex | nil ].
		v ifNotNil: [ result at: l selector put: v ] ].
	^ SAObservationItem newForObject: theObject observers: result
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitPrimitive: theObject atDepth: anInteger [
	anInteger > self maxDepth ifTrue: [ ^ nil ].
	^ SAObservationItem newForPrimitive: theObject
]

{ #category : #visiting }
SAObjectObserversSerializer >> visitUndefinedObject: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]
