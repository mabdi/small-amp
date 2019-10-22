Class {
	#name : #SerializerFactoryTests,
	#superclass : #TestCase,
	#instVars : [
		'observations',
		'memory'
	],
	#category : #'Amplification-Tests'
}

{ #category : #tests }
SerializerFactoryTests >> testArray [
	| value |
	value := SerializerFactory serialize: {1 . 2 . 3 . 4 . 5 . 6}.
	self assert: (value at: #type) equals: #collection.
	self assert: (value at: #class) equals: Array.
	self assert: (value at: #value) size equals: 6.
	self assert: (((value at: #value) at: 3) at: #value) equals: '3'.
	self
		assert: (((value at: #value) at: 3) at: #class)
		equals: SmallInteger
]

{ #category : #tests }
SerializerFactoryTests >> testArray2D [
	| value matrix23 |
	matrix23 := Array2D rows: 3 columns: 2.
	matrix23 at: 1 at: 1 put: 11.
	matrix23 at: 1 at: 2 put: 21.
	matrix23 at: 2 at: 1 put: 12.
	matrix23 at: 2 at: 2 put: 22.
	matrix23 at: 3 at: 1 put: 13.
	matrix23 at: 3 at: 2 put: 23.
	value := SerializerFactory serialize: matrix23.
	self assert: (value at: #type) equals: #array2d.
	self assert: (value at: #class) equals: Array2D.
	self assert: (value at: #value) size equals: 6.
	self assert: (((value at: #value) at: 3) at: #value) equals: '12'.
	self
		assert: (((value at: #value) at: 3) at: #class)
		equals: SmallInteger.
	self
		assert: (value at: #value) asString
		equals:
			'an OrderedCollection(a Dictionary(#class->SmallInteger #type->#primitive #value->''11'' ) a Dictionary(#class->SmallInteger #type->#primitive #value->''21'' ) a Dictionary(#class->SmallInteger #type->#primitive #value->''12'' ) a Dictionary(#class->SmallInteger #type->#primitive #value->''22'' ) a Dictionary(#class->SmallInteger #type->#primitive #value->''13'' ) a Dictionary(#class->SmallInteger #type->#primitive #value->''23'' ))'
]

{ #category : #tests }
SerializerFactoryTests >> testArrayWithArray [
	| value |
	value := SerializerFactory
		serialize:
			{1.
			2.
			{3}.
			4.
			5.
			6}.
	self assert: (value at: #type) equals: #collection.
	self assert: (value at: #class) equals: Array.
	self assert: (value at: #value) size equals: 6.
	self
		assert: (((value at: #value) at: 3) at: #value) asString
		equals:
			'an OrderedCollection(a Dictionary(#class->SmallInteger #type->#primitive #value->''3'' ))'.
	self assert: (((value at: #value) at: 3) at: #class) equals: Array
]

{ #category : #tests }
SerializerFactoryTests >> testBoolean [
	| value |
	value := SerializerFactory serialize: true.
	self assert: (value at: #type) equals: #primitive.
	self assert: (value at: #class) equals: True.
	self assert: (value at: #value) equals: 'true'
]

{ #category : #tests }
SerializerFactoryTests >> testCharacter [
	| value |
	value := SerializerFactory serialize: $t.
	self assert: (value at: #type) equals: #primitive.
	self assert: (value at: #class) equals: Character.
	self assert: (value at: #value) equals: 't'
]

{ #category : #tests }
SerializerFactoryTests >> testFloat [
	| value |
	value := SerializerFactory serialize: 1.54.
	self assert: (value at: #type) equals: #primitive.
	self assert: (value at: #class) equals: SmallFloat64.
	self assert: (value at: #value) equals: '1.54'
]

{ #category : #tests }
SerializerFactoryTests >> testInt [
	| value |
	value := SerializerFactory serialize: 10.
	self assert: (value at: #type) equals: #primitive.
	self assert: (value at: #class) equals: SmallInteger.
	self assert: (value at: #value) equals: '10'
]

{ #category : #tests }
SerializerFactoryTests >> testObject1 [
	| value |
	value := SerializerFactory serialize: 1 @ 2.
	self assert: (value at: #type) equals: #object.
	self assert: (value at: #class) equals: Point.
	self
		assert: (value at: #value) asString
		equals:
			'a Dictionary(#x->a Dictionary(#class->SmallInteger #type->#primitive #value->''1'' ) #y->a Dictionary(#class->SmallInteger #type->#primitive #value->''2'' ) )'
]

{ #category : #tests }
SerializerFactoryTests >> testString [
	| value |
	value := SerializerFactory serialize: 'Hello World'.
	self assert: (value at: #type) equals: #primitive.
	self assert: (value at: #class) equals: ByteString.
	self assert: (value at: #value) equals: 'Hello World'
]

{ #category : #tests }
SerializerFactoryTests >> testUnArray [
	| value temp data |
	data := {1 .2 .3 .4 .5 .6}.
	temp := SerializerFactory  serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data
]

{ #category : #tests }
SerializerFactoryTests >> testUnArrayWithArray [
	| value temp data |
	data := {1.
			2.
			{3}.
			4.
			5.
			6}.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data
]

{ #category : #tests }
SerializerFactoryTests >> testUnBoolean [
	
	| value temp data |
	data := true.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data
]

{ #category : #tests }
SerializerFactoryTests >> testUnCharacter [
	
	| value temp data |
	data := $t.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data
]

{ #category : #tests }
SerializerFactoryTests >> testUnFloat [
	
	| value temp data |
	data := 1.54.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data
]

{ #category : #tests }
SerializerFactoryTests >> testUnInt [
	
	| value temp data |
	data := 10.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data
]

{ #category : #tests }
SerializerFactoryTests >> testUnObject1 [
	| value temp data |
	data := 1 @ 2.
	temp := SerializerFactory serialize: data.
	value := SerializerFactory unserialize: temp.
	self
		assert: value asString
		equals:
			'a Dictionary(#x->a Dictionary(#class->SmallInteger #type->#primitive #value->''1'' ) #y->a Dictionary(#class->SmallInteger #type->#primitive #value->''2'' ) )'
]

{ #category : #tests }
SerializerFactoryTests >> testUnString [
	| value temp data |
	data := 'Hello World'.
	temp := SerializerFactory  serialize: data.
	value := SerializerFactory unserialize: temp.
	self assert: value equals: data
]
