Class {
	#name : #SerializerFactory,
	#superclass : #Object,
	#classInstVars : [
		'serializers'
	],
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
SerializerFactory class >> getSerializer: anObject [
	self serializers
		detect: [ :s | s canSerialize: anObject ]
		ifFound: [ :s | ^ s serializer: anObject ]
]

{ #category : #'as yet unclassified' }
SerializerFactory class >> getUnserializer: aDic [
	| unserializer |
	unserializer := aDic
		at: #unserializer
		ifAbsent: [ aDic
				at: #unserializer
				put:
					(self serializers
						detect: [ :s | s canUnSerialize: aDic ]
						ifFound: [ :s | ^ s unserializer: aDic ]
						ifNone: [self error: 'No unserializer' ]) ].
	^ unserializer
]

{ #category : #'as yet unclassified' }
SerializerFactory class >> serialize: anObject [
	^ (self getSerializer: anObject ) serialize
]

{ #category : #'as yet unclassified' }
SerializerFactory class >> serialize: anObject depth: anInt [
	^ (self getSerializer: anObject) serializeDepth: anInt
]

{ #category : #accessing }
SerializerFactory class >> serializers [
	^ serializers
		ifNil: [ serializers := (AbstractSerializer allSubclasses
				select: [ :s | s priority > 0 ])
				sorted: [ :s1 :s2 | s1 priority < s2 priority ] ]
]

{ #category : #'as yet unclassified' }
SerializerFactory class >> unserialize: aDic [
	^ (self getUnserializer: aDic) unserialize
]
