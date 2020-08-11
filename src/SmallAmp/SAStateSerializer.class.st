Class {
	#name : #SAStateSerializer,
	#superclass : #Object,
	#instVars : [
		'maxDepth'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SAStateSerializer class >> withDepth: anInt [ 
	^ self new maxDepth: anInt ; yourself
]

{ #category : #'as yet unclassified' }
SAStateSerializer >> filterObserversOn: theObject [
	| methods theClass |
	theClass := theObject class.
	methods := OrderedCollection new.
	self maxSuperClass
		timesRepeat: [ theClass == Object
				ifFalse: [ methods addAll: (theClass methods select: #smallAmpIsAccessor).
					theClass := theClass superclass ] ].
	methods := methods
		select: [ :method | 
			method selector first isLetter
				and: [ (method selector indexOf: $:) = 0 ] ].
	methods := methods select: [ :m | m ast lastIsReturn ].
	methods := methods select: [ :m | m smallAmpIsPure ].
	methods := methods sort: [ :a :b | a selector <= b selector ].
	^ methods
]

{ #category : #accessing }
SAStateSerializer >> maxDepth [
	^ maxDepth ifNil: [ maxDepth := 2 ]
]

{ #category : #accessing }
SAStateSerializer >> maxDepth: anInt [
	maxDepth := anInt
]

{ #category : #accessing }
SAStateSerializer >> maxSuperClass [
	^ 2
]

{ #category : #visiting }
SAStateSerializer >> visitBlockClosure: theObject atDepth: anInteger [
	anInteger > self maxDepth
		ifTrue: [ ^ nil ].
	^ SAObservationBlockClosure
		newFor: theObject 
		atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitByteString: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitByteSymbol: theObject atDepth: anInteger [
^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitChar: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitClass: theObject atDepth: anInteger [
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
			v := [ item
				smallAmpAcceptSerializerVisitor: self
				atDepth: anInteger + 1 ]
				on: Error
				do: [ :ex | nil ].
			aCollection add: v ].
	^ SAObservationCollection
		newForClass: theObject class
		values: aCollection
		atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitCompiledCode: theObject atDepth: anInteger [
	anInteger > self maxDepth
		ifTrue: [ ^ nil ].
	^ SAObservationCompiledCode newFor: theObject atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitDateTime: theObject atDepth: anInteger [
	anInteger > self maxDepth
		ifTrue: [ ^ nil ].
	^ SAObservationDateTime 
		newForClass: theObject class
		values: theObject
		atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitFalse: theObject atDepth: anInteger [
	anInteger > self maxDepth ifTrue: [ ^ nil ].
	^ SAObservationFalse newAtDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitFraction: theObject atDepth: anInteger [
	anInteger > self maxDepth
		ifTrue: [ ^ nil ].
	^ SAObservationFraction
		newForClass: theObject class
		values: theObject
		atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitNumber: theObject atDepth: anInteger [
		^ self visitPrimitive: theObject atDepth: anInteger
]

{ #category : #visiting }
SAStateSerializer >> visitObject: theObject atDepth: anInteger [
| result methods |
anInteger > self maxDepth
ifTrue: [ ^ nil ].
result := Dictionary new.
methods := self filterObserversOn: theObject.
methods
do: [ :l | 
| retVal v |

[ 
retVal := theObject perform: l selector.
retVal == theObject
ifFalse: [ v := retVal
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
SAStateSerializer >> visitRBProgramNode: theObject atDepth: anInteger [
	anInteger > self maxDepth
		ifTrue: [ ^ nil ].
	
	^ SAObservationRBProgramNode newForClass: theObject class values: theObject atDepth: anInteger
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
