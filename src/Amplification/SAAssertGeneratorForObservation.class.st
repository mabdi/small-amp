Class {
	#name : #SAAssertGeneratorForObservation,
	#superclass : #Object,
	#category : #'Amplification-Helpers'
}

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> makeClassNameAssertForName: aName class: theClass [
	| assertStatement theObject theValue |
	theClass isTestCase ifTrue: [ ^ {  } ].
	theObject := RBMessageNode
		             receiver: (RBVariableNode named: aName)
		             selector: #class.
	theValue := RBVariableNode named: theClass name.
	assertStatement := RBMessageNode
		                   receiver: (RBSelfNode named: 'self')
		                   selector: #assert:equals:description:
		                   arguments: { 
				                   theObject.
				                   theValue.
				                   (RBLiteralValueNode value: 'smallAmp') }.
	^ { assertStatement }
]

{ #category : #'as yet unclassified' }
SAAssertGeneratorForObservation >> makePrimitiveAssertForName: aName value: anObservationItem [
	| assertStatements theObject theValue variableValue |
	assertStatements := OrderedCollection new.
	anObservationItem isFlaky ifTrue: [ ^ assertStatements ].
	theObject := RBVariableNode named: aName.
	variableValue := anObservationItem theValue.
	theValue := RBLiteralValueNode value: variableValue.
	assertStatements add: (RBMessageNode
			 receiver: (RBSelfNode named: 'self')
			 selector: #assert:equals:description:
			 arguments: { 
					 theObject.
					 theValue.
					 (RBLiteralValueNode value: 'smallAmp') }).
	assertStatements addAllFirst: (self
			 makeClassNameAssertForName: aName
			 class: anObservationItem theClass).
	^ assertStatements
]
