"
A SAObjectObserversSerializerTest is a test class for testing the behavior of SAObjectObserversSerializer
"
Class {
	#name : #SAObjectObserversSerializerTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #test }
SAObjectObserversSerializerTest >> testFilterObserversOn [
	"Here we are testing the filterObserversOn on a few different type"

	"this test may fail, depend on change on the structure of these types"

	| obj res serializer |
	obj := SmallBank new.
	serializer := SAObjectObserversSerializer new.
	res := serializer filterObserversOn: obj.
	"an OrderedCollection(SmallBank>>#balance SmallBank>>#rand)"
	self assert: res size equals: 2.
	obj := SAObservationObject new.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 7.
	"an OrderedCollection(SAObservationValue>>#depth SAObservationValue>>#isFlaky SAObservationValue>>#isValueObservation SAObservationValue>>#name SAObservationValue>>#observedBy SAObservationValue>>#theClass SAObservationValue>>#theValue)"
	obj := SAObservationPrimitive new.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 1.
	"an OrderedCollection(SAObservationPrimitive>>#isPrimitive)"
	obj := #key -> 0.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 5.
	"an OrderedCollection(LookupKey>>#isVariableBinding LookupKey>>#key LookupKey>>#name Association>>#needsFullDefinition Association>>#value)"
	obj := 1 @ 1.
	res := serializer filterObserversOn: obj.
	self assert: res size equals: 6
	"an OrderedCollection(Point>>#isFloatPoint Point>>#isIntegerPoint Point>>#isPoint Point>>#isZero Point>>#x Point>>#y)"
]
