Class {
	#name : #SAAssertGenerator,
	#superclass : #Object,
	#category : #'SmallAmp-Helpers'
}

{ #category : #'as yet unclassified' }
SAAssertGenerator class >> blockPlaceHolder [
	^ 'smallAmpBlockPlaceHolder'
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> appendCollectionMyName: name ToAssert: aRBMessageNode [
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
SAAssertGenerator >> appendMyName: name ToAssert: aRBMessageNode [
	| tmp msgNode |
	tmp := aRBMessageNode arguments at: 1.
	(tmp formattedCode prefixMatchesRegex: '\(+')
		ifTrue: [ msgNode := RBParser
				parseExpression:
					(tmp formattedCode
						copyWithRegex: '^\(+'
						matchesTranslatedUsing: [ :b | b , name , ' ' ]) ]
		ifFalse:
			[ msgNode := RBParser parseExpression: name , ' ' , tmp formattedCode ].
	aRBMessageNode arguments at: 1 put: msgNode
]

{ #category : #asserting }
SAAssertGenerator >> assertCollectionIncludeValues: observation [
	| assertStatements |
	assertStatements := OrderedCollection new.
	(observation theValue allSatisfy: [ :item | item isNil ])
		ifTrue: [ ^ assertStatements ].
	(observation theValue allSatisfy: [ :item | item isPrimitive ])
		ifTrue: [ ^ assertStatements ].
	observation theValue size > self maxCollectionSize
		ifTrue: [ ^ assertStatements ].
	observation theValue
		withIndexDo: [ :item :index | 
			(observation theValue at: index)
				name: self temp_arrayElementNamePrefix , index asString.
			assertStatements
				addAll: ((observation theValue at: index) buildAssertions: self) ].
	assertStatements := assertStatements reject: #isNil.
	assertStatements
		do:
			[ :assertion | self appendCollectionMyName: observation name ToAssert: assertion ].
	^ assertStatements
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertCollectionPrimitiveValues: observation [
	| assertStatement theObject theValueNode array |
	(observation theValue allSatisfy: [ :item | item isNil ])
		ifTrue: [ ^ nil ].
	(observation theValue allSatisfy: [ :item | item isPrimitive ])
		ifFalse: [ ^ nil ].
	observation theValue size > self maxCollectionSize
		ifTrue: [ ^ nil ].
	observation theValue ifEmpty: [ ^ nil ].
	array := (observation theValue collect: [ :item | item theValue ])
		asArray.
	theObject := RBMessageNode
		receiver: (RBVariableNode named: observation name)
		selector: #asArray.
	theValueNode := RBLiteralArrayNode value: array.
	(theValueNode asString
		includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ SAUnprintableNonliteralValue new signal ].
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValueNode}.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertCollectionPrimitiveValuesAsString: observation [
	| assertStatement theObject theValueNode array |
	(observation theValue allSatisfy: [ :item | item isNil ])
		ifTrue: [ ^ nil ].
	(observation theValue allSatisfy: [ :item | item isPrimitive ])
		ifFalse: [ ^ nil ].
	observation theValue size > self maxCollectionSize
		ifTrue: [ ^ nil ].
	observation theValue ifEmpty: [ ^ nil ].
	array := (observation theValue collect: [ :item | item theValue ])
		asArray.
	theObject := RBMessageNode
		receiver:
			(RBMessageNode
				receiver: (RBVariableNode named: observation name)
				selector: #asArray)
		selector: #collect:
		arguments: {(RBLiteralValueNode value: #asString)}.
	theValueNode := RBLiteralArrayNode value: array.
	assertStatement := RBMessageNode
		receiver: (RBSelfNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValueNode}.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertCollectionSize: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theObject := RBMessageNode receiver: theObject selector: #size.
	theValueNode := RBLiteralValueNode value: observation theValue size.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:
		                   arguments: { 
				                   theObject.
				                   theValueNode }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGenerator >> assertEmpty: observation [
	| assertStatement theObject |
	theObject := RBVariableNode named: observation name.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assertEmpty:
		                   arguments: { 
				                   theObject }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertError: anObservation [
	| assertStatement theMessage theErrorNode  |
	theMessage := RBVariableNode named: self class blockPlaceHolder.
	theErrorNode := RBVariableNode named: anObservation theError name.
	
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #should:raise:
		                   arguments: { 
				                   theMessage.
				                   theErrorNode }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGenerator >> assertFalse: observation [
	| assertStatement theObject |
	theObject := RBVariableNode named: observation name.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #deny:
		                   arguments: { 
				                   theObject}.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGenerator >> assertNil: observation [
	| assertStatement theObject |
	theObject := RBVariableNode named: observation name.
	theObject := RBMessageNode receiver: theObject selector: #isNil.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:
		                   arguments: { 
				                   theObject }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertPrimitiveValue: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theValueNode := RBLiteralValueNode value: observation theValue.
	(theValueNode asString includesSubstring: '<an unprintable nonliteral value>') ifTrue: [SAUnprintableNonliteralValue new signal].
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:
		                   arguments: { 
				                   theObject.
				                   theValueNode }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertPrimitiveValueAsString: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theObject := RBMessageNode receiver: theObject selector: #asString.
	theValueNode := RBLiteralValueNode value:
		                observation theValue asString.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:
		                   arguments: { 
				                   theObject.
				                   theValueNode }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGenerator >> assertTimeout: observation [
	| assertStatement theMessage theTimeOut |
	theMessage := RBVariableNode named: self class blockPlaceHolder.
	theTimeOut := RBMessageNode
		              receiver: (RBVariableNode named: 'Duration')
		              selector: #milliSeconds:
		              arguments:
		              { (RBLiteralValueNode value: observation timeout) }.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #should:takeMoreThan:
		                   arguments: { 
				                   theMessage.
				                   theTimeOut }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGenerator >> assertTrue: observation [
	| assertStatement theObject |
	theObject := RBVariableNode named: observation name.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:
		                   arguments: { 
				                   theObject }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertType: observation [
	| assertStatement theObject thClassName |
	observation theClass isTestCase ifTrue: [ ^ {  } ].
	theObject := RBMessageNode
		             receiver: (RBVariableNode named: observation name)
		             selector: #class.
	thClassName := RBVariableNode named: observation theClass name.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:
		                   arguments: { 
				                   theObject.
				                   thClassName}.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsCollectionObservation: observation [
	| assertStatements |
	assertStatements := OrderedCollection new.
	assertStatements add: (self assertType: observation).
	assertStatements
		add:
			(observation theValue isEmpty
				ifTrue: [ self assertEmpty: observation ]
				ifFalse: [ self assertCollectionSize: observation ]).
	assertStatements
		add: ([ self assertCollectionPrimitiveValues: observation ]
		on: SAUnprintableNonliteralValue
		do: [ self assertCollectionPrimitiveValuesAsString: observation ]).
	assertStatements
		addAll: (self assertCollectionIncludeValues: observation).
	"assertStatements add:
		(self buildAssertionsObjectObservation: observation)."
	assertStatements := assertStatements reject: #isNil.
	^ assertStatements
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsErrorObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertError: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsFalseObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertFalse: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsFractionObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertType: observation).
	observation isFlaky ifFalse: [ 
		asserts add: (self assertPrimitiveValueAsString: observation) ].
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsNilObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertNil: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsObjectObservation: observation [
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
SAAssertGenerator >> buildAssertionsPrimitiveObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	observation isFlaky
		ifTrue: [ asserts add: (self assertType: observation) ]
		ifFalse: [ asserts
				add:
					([ self assertPrimitiveValue: observation ]
						on: SAUnprintableNonliteralValue
						do: [ self assertPrimitiveValueAsString: observation ]) ].
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsTimeoutObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertTimeout: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsTrueObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertTrue: observation).
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #accessing }
SAAssertGenerator >> maxCollectionSize [
	^ 10
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> temp_arrayElementNamePrefix [
	^ 'at_'
]
