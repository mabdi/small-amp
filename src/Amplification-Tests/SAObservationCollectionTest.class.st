"
A SAObservationCollectionTest is a test class for testing the behavior of SAObservationCollection
"
Class {
	#name : #SAObservationCollectionTest,
	#superclass : #TestCase,
	#category : #'Amplification-Tests-Model'
}

{ #category : #tests }
SAObservationCollectionTest >> testArray [
	| item arr s1 |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationCollection.
	self assert: item theClass equals: Array.
	self assert: item theValue isNotEmpty.
	self assert: item theValue size equals: 3.
	s1 := 10
		      smallAmpAcceptSerializerVisitor:
		      SAObjectObserversSerializer new
		      atDepth: 0.
	self assert: (item theValue at: 1) theClass equals: s1 theClass.
	self assert: (item theValue at: 1) theValue equals: s1 theValue.
	self assert: (item theValue at: 2) theValue equals: 20.
	self assert: (item theValue at: 2) theClass equals: SmallInteger
]

{ #category : #tests }
SAObservationCollectionTest >> testArray2D [
	| item matrix23 s1 |
	matrix23 := Array2D rows: 3 columns: 2.
	matrix23 at: 1 at: 1 put: 11.
	matrix23 at: 1 at: 2 put: 21.
	matrix23 at: 2 at: 1 put: 12.
	matrix23 at: 2 at: 2 put: 22.
	matrix23 at: 3 at: 1 put: 13.
	matrix23 at: 3 at: 2 put: 23.
	item := matrix23
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationCollection.
	self assert: item theClass equals: Array2D.
	self assert: item theValue isNotEmpty.
	self assert: item theValue size equals: 6.
	s1 := 12
		      smallAmpAcceptSerializerVisitor:
		      SAObjectObserversSerializer new
		      atDepth: 0.
	self assert: (item theValue at: 3) theClass equals: s1 theClass.
	self assert: (item theValue at: 3) theValue equals: s1 theValue.
	self assert: (item theValue at: 4) theValue equals: 22.
	self assert: (item theValue at: 4) theClass equals: SmallInteger
]

{ #category : #tests }
SAObservationCollectionTest >> testArrayDeep [
	| item arr s2 |
	arr := Array with: 10 with: { 'hello'. 1. true }.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	self assert: item class equals: SAObservationCollection.
	self assert: item theClass equals: Array.
	self assert: item theValue isNotEmpty.
	self assert: item theValue size equals: 2.
	s2 := { 'hello'. 1. true }
		      smallAmpAcceptSerializerVisitor:
		      SAObjectObserversSerializer new
		      atDepth: 0.
		self assert: (item theValue at: 2) class equals: SAObservationCollection .
	self assert: (item theValue at: 2) theClass equals: s2 theClass.
	self assert: (item theValue at: 2) theClass equals: Array.
	self assert: (item theValue at: 2) theValue size equals: 3.
	self
		assert: ((item theValue at: 2) theValue at: 1) class
		equals: SAObservationPrimitive.
	self
		assert: ((item theValue at: 2) theValue at: 1) theValue
		equals: 'hello'.
	self
		assert: ((item theValue at: 2) theValue at: 2) theValue
		equals: 1.
	self
		assert: ((item theValue at: 2) theValue at: 3) theValue
		equals: true
]

{ #category : #test }
SAObservationCollectionTest >> testBuildAssertionSize [
	| arr item |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	item name: 'foo'.
	self assert: item buildAssertionSize formattedCode equals: 'self assert: foo size equals: 3 description: ''smallAmp'''
]

{ #category : #test }
SAObservationCollectionTest >> testBuildAssertionValues [
	| arr item |
	arr := Array with: 10 with: 20 with: 30.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	item name: 'foo'.
	self assert: item buildAssertionValues formattedCode equals: 'self assert: foo equals: #( 10 20 30 ) description: ''smallAmp'''
]

{ #category : #test }
SAObservationCollectionTest >> testBuildAssertionValuesMax [
	| arr item |
	arr := (1 to: 100) asArray .
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	item name: 'foo'.
	self assert: item buildAssertionValues equals: nil
]

{ #category : #test }
SAObservationCollectionTest >> testBuildAssertionValuesNonPrimitive [
	| arr item |
	arr := Array with: 10 with: 20 with: 30 @ 1.
	item := arr
		        smallAmpAcceptSerializerVisitor:
		        SAObjectObserversSerializer new
		        atDepth: 0.
	item name: 'foo'.
	self
		assert: item buildAssertionValues 
		equals:
 nil
]

{ #category : #test }
SAObservationCollectionTest >> testCheckFlaky [
	| item1 item2 arr1 arr2 |
	arr1 := Array with: 10 with: 20 with: 30.
	arr2 := Array with: 11 with: 20 with: 30.
	item1 := arr1
		         smallAmpAcceptSerializerVisitor:
		         SAObjectObserversSerializer new
		         atDepth: 0.
	item2 := arr2
		         smallAmpAcceptSerializerVisitor:
		         SAObjectObserversSerializer new
		         atDepth: 0.
	self deny: (item1 theValue at: 1) isFlaky.
	self deny: (item1 theValue at: 2) isFlaky.
	self deny: (item1 theValue at: 3) isFlaky.
	item1 checkFlaky: item2.
	self assert: (item1 theValue at: 1) isFlaky.
	self deny: (item1 theValue at: 2) isFlaky.
	self deny: (item1 theValue at: 3) isFlaky
]
