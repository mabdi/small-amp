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
		newNode parent: aRBMessageNode.
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
		msgNode parent: aRBMessageNode .
	aRBMessageNode arguments at: 1 put: msgNode
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertBlockValueAsString: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theObject := RBMessageNode
		receiver: (RBMessageNode receiver: theObject selector: #sourceNode)
		selector: #formattedCode.
	theValueNode := observation valueNode.
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValueNode}.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertClass: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theValueNode := observation valueNode.
	(theValueNode asString
		includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ SAUnprintableNonliteralValue new signal ].
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValueNode}.
	^ assertStatement
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
	theObject := observation theClass = Array
		ifFalse: [ RBMessageNode
				receiver: (RBVariableNode named: observation name)
				selector: #asArray ]
		ifTrue: [ RBVariableNode named: observation name ].
	theValueNode := RBLiteralArrayNode value: array.
	(theValueNode asString
		includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ SAUnprintableNonliteralValue new signal ].
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
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
	array := (observation theValue collect: [ :item | item theValue asString ])
		asArray.
	theObject := observation theClass = Array
		ifFalse: [ RBMessageNode
				receiver: (RBVariableNode named: observation name)
				selector: #asArray ]
		ifTrue: [ RBVariableNode named: observation name ].
	theObject := RBMessageNode
		receiver: theObject
		selector: #collect:
		arguments: {(RBLiteralValueNode value: #asString)}.
	theValueNode := RBLiteralArrayNode value: array.
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
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
		                   receiver: (RBVariableNode named: 'self')
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
		                   receiver: (RBVariableNode named: 'self')
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
		                   receiver: (RBVariableNode named: 'self')
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
		                   receiver: (RBVariableNode named: 'self')
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
		                   receiver: (RBVariableNode named: 'self')
		                   selector: #assert:
		                   arguments: { 
				                   theObject }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGenerator >> assertPoint: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theValueNode := RBMessageNode
		receiver: ( (observation theValue at: #x) valueNode)
		selector: #@
		arguments: {((observation theValue at: #y) valueNode)}.
	(theValueNode asString
		includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ SAUnprintableNonliteralValue new signal ].
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValueNode}.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertPrimitiveAsUTCAsString: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theObject := RBMessageNode
		receiver: (RBMessageNode receiver: theObject selector: #asUTC)
		selector: #asString.
	theValueNode := RBLiteralValueNode
		value: observation theValue asUTC asString.
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValueNode}.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertPrimitiveValue: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theValueNode := observation valueNode.
	(theValueNode asString
		includesSubstring: '<an unprintable nonliteral value>')
		ifTrue: [ SAUnprintableNonliteralValue new signal ].
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			theValueNode}.
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
		                   receiver: (RBVariableNode named: 'self')
		                   selector: #assert:equals:
		                   arguments: { 
				                   theObject.
				                   theValueNode }.
	^ assertStatement
]

{ #category : #asserting }
SAAssertGenerator >> assertRBProgramNode: observation [
	| assertStatement theObject theValueNode |
	theObject := RBVariableNode named: observation name.
	theObject := RBMessageNode
		receiver: theObject
		selector: #formattedCode.
	theValueNode := observation valueNode .
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
		selector: #assertSourceCode:equals:
		arguments:
			{theObject.
			theValueNode}.
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
		                   receiver: (RBVariableNode named: 'self')
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
		                   receiver: (RBVariableNode named: 'self')
		                   selector: #assert:
		                   arguments: { 
				                   theObject }.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> assertType: observation [
	| assertStatement theObject thClassName |
	observation theClass isTestCase
		ifTrue: [ ^ nil ].
	theObject := RBMessageNode
		receiver: (RBVariableNode named: observation name)
		selector: #class.
	thClassName := RBVariableNode named: observation theClass name.
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
		selector: #assert:equals:
		arguments:
			{theObject.
			thClassName}.
	^ assertStatement
]

{ #category : #building }
SAAssertGenerator >> buildAssertObjectStateFor: observation [
	| assertStatement theObject theName theId theType |
	theObject := RBVariableNode named: observation name.
	theName := RBLiteralValueNode value: observation name.
	theId := RBLiteralValueNode value: observation id.
	theType := RBLiteralValueNode value: observation observedBy.
	assertStatement := RBMessageNode
		receiver: (RBVariableNode named: 'self')
		selector: #assertObjectState:varName:id:type:
		arguments:
			{theObject.
			theName.
			theId.theType}.
	^ assertStatement
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsBlockClosureObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	(self assertType: observation) ifNotNil: [:s |asserts add: s].
	asserts add: (self assertBlockValueAsString: observation).
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsClass: observation [
	| asserts |
	asserts := OrderedCollection new.
	(self assertClass: observation)
		ifNotNil: [ :s | asserts add: s ].
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsCollectionObservation: observation [
	| assertStatements |
	assertStatements := OrderedCollection new.
	(self assertType: observation) ifNotNil: [:s |assertStatements  add: s].
	assertStatements
		add:
			(observation theValue isEmpty
				ifTrue: [ self assertEmpty: observation ]
				ifFalse: [ self assertCollectionSize: observation ]).
	assertStatements
		add:
			([ self assertCollectionPrimitiveValues: observation ]
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
SAAssertGenerator >> buildAssertionsCompiledCode: observation [
	| asserts |
	asserts := OrderedCollection new.
	(self assertType: observation) ifNotNil: [:s |asserts add: s].
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsDateTimeObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	observation isFlaky
		ifTrue: [ (self assertType: observation) ifNotNil: [:s |asserts add: s]. ]
		ifFalse: [ asserts add: (self assertPrimitiveAsUTCAsString: observation) ].
	asserts := asserts reject: #isNil.
	^ asserts
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
	(self assertType: observation) ifNotNil: [ :s | asserts add: s ].
	observation isFlaky
		ifFalse: [ asserts add: (self assertPrimitiveValueAsString: observation) ].
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
	observation theValue
		keysDo: [ :key | 
			(observation theValue at: key) name: key.
			asserts
				addAll: ((observation theValue at: key) buildAssertions: self) ].
	asserts := asserts reject: #isNil.
	asserts
		do:
			[ :assertion | self appendMyName: observation name ToAssert: assertion ].
	(self assertType: observation) ifNotNil: [:s |asserts addFirst: s].
	^ asserts
]

{ #category : #asserting }
SAAssertGenerator >> buildAssertionsPoint: observation [
	| asserts |
	asserts := OrderedCollection new.
	observation theValue
		at: #x
		ifPresent: [ (self assertPoint: observation) ifNotNil: [ :s | asserts add: s ] ]
		ifAbsent: [ (self assertType: observation) ifNotNil: [ :s | asserts add: s ]. ].
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsPrimitiveObservation: observation [
	| asserts |
	asserts := OrderedCollection new.
	observation isFlaky
		ifTrue: [ (self assertType: observation)
				ifNotNil: [ :s | asserts add: s ] ]
		ifFalse: [ asserts
				add:
					([ self assertPrimitiveValue: observation ]
						on: SAUnprintableNonliteralValue
						do: [ self assertPrimitiveValueAsString: observation ]) ].
	asserts := asserts reject: #isNil.
	^ asserts
]

{ #category : #'as yet unclassified' }
SAAssertGenerator >> buildAssertionsRBProgramNode: observation [
	| asserts |
	asserts := OrderedCollection new.
	asserts add: (self assertRBProgramNode: observation).
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
