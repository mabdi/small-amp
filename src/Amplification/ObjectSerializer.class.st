Class {
	#name : #ObjectSerializer,
	#superclass : #AbstractSerializer,
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
ObjectSerializer class >> abstract [
	^ false
]

{ #category : #private }
ObjectSerializer class >> canSerialize: anObject [
	^ true
]

{ #category : #private }
ObjectSerializer class >> canUnSerialize: anObject [
	^ true
]

{ #category : #asserting }
ObjectSerializer class >> makeAssertName: aName value: aValue last: theLast [
	| assertStatements changes |
	(aValue at: #value) ifNil: [ ^ {} ].
	changes := (aValue at: #value) keys
		select: [ :k | 
			theLast isNil
				or: [ ((SerializerFactory getUnserializer: ((aValue at: #value) at: k))
						isEqualWith: ((theLast at: #value) at: k)) not ] ].
	assertStatements := OrderedCollection new.
	changes
		do: [ :k | 
			assertStatements
				addAll:
					((SerializerFactory getUnserializer: ((aValue at: #value) at: k))
						class
						makeAssertName: k
						value: ((aValue at: #value) at: k)
						last: (theLast ifNotNil: [ (theLast at: #value) at: k ])) ].
	assertStatements
		do: [ :aRBMessageNode | 
			| tmp msgNode |
			tmp := aRBMessageNode arguments at: 1.
			"msgNode := RBMessageNode receiver: (RBVariableNode named: aName) selector: tmp name."
			msgNode := RBParser parseExpression: aName, ' ', tmp formattedCode.
			aRBMessageNode arguments at: 1 put: msgNode ].
	^ assertStatements
]

{ #category : #'as yet unclassified' }
ObjectSerializer class >> myTag [ ^ #object
]

{ #category : #accessing }
ObjectSerializer class >> priority [
	^ 30
]

{ #category : #'as yet unclassified' }
ObjectSerializer class >> supportingTypes [
	^ {  }
]

{ #category : #'as yet unclassified' }
ObjectSerializer class >> unserialize: dictionary [
	^ dictionary at: #value
]

{ #category : #testing }
ObjectSerializer >> isEqualWith: theLast [
	(dictionary at: #class) = (theLast at: #class)
		ifFalse: [ ^ false ]
		ifTrue: [ ^ (dictionary at: #value) keys
				allSatisfy: [ :k | 
					(SerializerFactory getUnserializer: ((dictionary at: #value) at: k)) 
					
						isEqualWith: ((theLast at: #value) at: k) ] ]
]

{ #category : #asserting }
ObjectSerializer >> makeAssertsBasedOnLast: theLast [
	^ self class
		makeAssertName: (dictionary at: #name)
		value: dictionary
		last: nil "disable differential"
]

{ #category : #'as yet unclassified' }
ObjectSerializer >> objectSerializeAccessing: anObject depth: anInt [
	| result |
	result := Dictionary new.
	
	((anObject class methodsInProtocol: #accessing)
		select: [ :method | (method selector indexOf: $:) = 0 ])
		do: [ :l | 
			result
				at: l selector
				put:
					(SerializerFactory
						serialize: (anObject perform: l selector)
						depth: anInt) ].
	^ result
]

{ #category : #'as yet unclassified' }
ObjectSerializer >> objectSerializeInstanceVariables: anObject depth: anInt [
	| result |
	result := Dictionary new.
	anObject class instanceVariables
		do: [ :variable | 
			result
				at: variable
				put:
					((SerializerFactory getSerializer: (anObject instVarNamed: variable))
						serializeSpecialDepth: anInt
						type: #instanceVariable
						extra: nil) ].
	^ result
]

{ #category : #'as yet unclassified' }
ObjectSerializer >> objectSerializeProfile: anObject depth: anInt [
	"| result |
	result := Dictionary new.
	((anObject class methodsInProtocol: #accessing)
		select: [ :method | (method selector indexOf: $:) = 0 ])
		do: [ :l | 
			result
				at: l selector
				put:
					(SerializerFactory
						serialize: (anObject perform: l selector)
						depth: anInt) ].
	^ result"
]

{ #category : #private }
ObjectSerializer >> serializeDepth: anInt [
	^ self serializeSpecialDepth: anInt type: #accessing extra: nil
]

{ #category : #private }
ObjectSerializer >> serializeSpecialDepth: anInt type: aString extra: anObject [
	| value |
	value := nil.
	anInt - 1 > 0
		ifTrue: [ aString = #accessing
				ifTrue: [ value:= self objectSerializeAccessing: object depth: anInt - 1 ].
			aString = #profile
				ifTrue: [ value:= self objectSerializeProfile: anObject depth: anInt - 1 ].
			aString = #instanceVariable
				ifTrue: [ value:= self objectSerializeInstanceVariables: object depth: anInt - 1 ] ].
	^ Dictionary
		newFrom:
			{(#value -> value).
			(#class -> object class).
			(#type -> self class myTag)}
]
