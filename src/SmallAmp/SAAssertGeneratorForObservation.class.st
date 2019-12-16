Class {
	#name : #SAAssertGeneratorForObservation,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> appendCollectionMyName: name ToAssert: aRBMessageNode [
	| newNode newName |
	newName := (aRBMessageNode arguments at: 1) formattedCode
		       copyWithRegex: self temp_arrayElementNamePrefix , '(\d+)'
		       matchesTranslatedUsing: [ :each | 
			       '(' , name , ' at: '
			       , (each allButFirst: self temp_arrayElementNamePrefix size)
			       , ')' ].
		newNode := RBParser parseExpression: newName.
	aRBMessageNode arguments at: 1 put: newNode
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> appendMyName: name ToAssert: aRBMessageNode [
	| tmp msgNode |
	tmp := aRBMessageNode arguments at: 1.
	msgNode := RBParser parseExpression: name , ' ' , tmp formattedCode.
	aRBMessageNode arguments at: 1 put: msgNode
]

{ #category : #asserting }
SAAssertGeneratorForObservation >> assertCollectionIncludeValues: observation [
	| assertStatements |
	assertStatements := OrderedCollection new.
	(observation theValue allSatisfy: [ :item | item isPrimitive ]) 
		ifTrue: [ ^ assertStatements ].
	observation theValue size > self maxCollectionSize ifTrue: [ 
		^ assertStatements ].
	
	observation theValue withIndexDo: [ :item :index | 
		(observation theValue at: index) name:
			self temp_arrayElementNamePrefix , index asString.
		assertStatements addAll:
			((observation theValue at: index) buildAssertions: self) ].
	assertStatements := assertStatements reject: #isNil.
	assertStatements do: [ :assertion | 
		self appendCollectionMyName: observation name ToAssert: assertion ].
	^ assertStatements
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> assertCollectionPrimitiveValues: observation [
	| assertStatement theObject theValueNode array |
	(observation theValue allSatisfy: [ :item | item isPrimitive ]) 
		ifFalse: [ ^ nil ].
	observation theValue size > self maxCollectionSize ifTrue: [ ^ nil ].
	observation theValue ifEmpty: [ ^ nil ]. 
	array := (observation theValue collect: [ :item | item theValue ])
		         asArray.
	theObject := RBVariableNode named: observation name.
	theValueNode := RBLiteralArrayNode value: array.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:description:
		                   arguments: { 
				                   theObject.
				                   theValueNode.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> assertCollectionSize: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theObject := RBMessageNode receiver: theObject selector: #size.
	theValueNode := RBLiteralValueNode value: observation theValue size.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:description:
		                   arguments: { 
				                   theObject.
				                   theValueNode.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGeneratorForObservation >> assertEmpty: observation [
	| assertStatement theObject |
	theObject := RBVariableNode named: observation name.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assertEmpty:description:
		                   arguments: { 
				                   theObject.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> assertError: anObservation [
	| assertStatement theMessage theErrorNode theDiscription |
	theMessage := RBVariableNode named: 'fake'.
	theErrorNode := RBVariableNode named: anObservation theError name.
	theDiscription := RBLiteralValueNode value: 'smallAmp'.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #should:raise:description:
		                   arguments: { 
				                   theMessage.
				                   theErrorNode.
				                   theDiscription }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGeneratorForObservation >> assertFalse: observation [
		| assertStatement theObject |
	theObject := RBVariableNode named: observation name.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #deny:description:
		                   arguments: { 
				                   theObject.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGeneratorForObservation >> assertNil: observation [
	| assertStatement theObject |
	theObject := RBVariableNode named: observation name.
		theObject := RBMessageNode receiver: theObject selector: #isNil.

	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:description:
		                   arguments: { 
				                   theObject.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> assertPrimitiveValue: observation [
	| assertStatement theObject theValueNode |
	
	theObject := RBVariableNode named: observation name.
	theValueNode := RBLiteralValueNode value: observation theValue.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:description:
		                   arguments: { 
				                   theObject.
				                   theValueNode.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> assertPrimitiveValueAsString: observation [
	| assertStatement theObject theValueNode |
	
	theObject := RBVariableNode named: observation name.
	theObject := RBMessageNode receiver: theObject selector: #asString.
	theValueNode := RBLiteralValueNode value:
		                observation theValue asString.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:description:
		                   arguments: { 
				                   theObject.
				                   theValueNode.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGeneratorForObservation >> assertTimeout: observation [
	| assertStatement theMessage theTimeOut theDiscription |
	theMessage := RBVariableNode named: 'fake'.
	theTimeOut := RBMessageNode
		              receiver: (RBVariableNode named: 'Duration')
		              selector: #milliSeconds:
		              arguments: { (RBLiteralValueNode value: observation timeout) }.
	theDiscription := RBLiteralValueNode value: 'smallAmp'.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #should:takeMoreThan:description:
		                   arguments: { 
				                   theMessage.
				                   theTimeOut.
				                   theDiscription }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGeneratorForObservation >> assertTrue: observation [
	| assertStatement theObject |
	theObject := RBVariableNode named: observation name.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:description:
		                   arguments: { 
				                   theObject.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> assertType: observation [
	| assertStatement theObject thClassName |
	observation theClass isTestCase ifTrue: [ ^ {  } ].
	theObject := RBMessageNode
		             receiver: (RBVariableNode named: observation name)
		             selector: #class.
	thClassName := RBVariableNode named: observation theClass name.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:description:
		                   arguments: { 
				                   theObject.
				                   thClassName.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> buildAssertionsCollectionObservation: observation [
	| assertStatements |
	assertStatements := OrderedCollection new.
	assertStatements add: (self assertType: observation).
	assertStatements add: (observation theValue isEmpty
			 ifTrue: [ self assertEmpty: observation ]
			 ifFalse: [ self assertCollectionSize: observation ]).
	assertStatements add:
		(self assertCollectionPrimitiveValues: observation).
	assertStatements addAll:
		(self assertCollectionIncludeValues: observation).
	"assertStatements add:
		(self buildAssertionsObjectObservation: observation)."
	assertStatements := assertStatements reject: #isNil.
	^ assertStatements
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> buildAssertionsErrorObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertError: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> buildAssertionsFalseObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertFalse: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> buildAssertionsFractionObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertType: observation).
	observation isFlaky ifFalse: [ 
		asserts add: (self assertPrimitiveValueAsString: observation) ].
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> buildAssertionsNilObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertNil: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> buildAssertionsObjectObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	observation theValue keysDo: [ :key | 
		(observation theValue at: key) name: key.
		asserts addAll: ((observation theValue at: key) buildAssertions: self) ].
	asserts := asserts reject: #isNil.
	asserts do: [ :assertion | 
		self appendMyName: observation name ToAssert: assertion ].
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> buildAssertionsPrimitiveObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertType: observation).
	observation isFlaky ifFalse: [ 
		asserts add: (self assertPrimitiveValue: observation) ].
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> buildAssertionsTimeoutObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertTimeout: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> buildAssertionsTrueObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertTrue: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #accessing }
SAAssertGeneratorForObservation >> maxCollectionSize [
	^ 10
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> temp_arrayElementNamePrefix [
	^ 'at_'
]
