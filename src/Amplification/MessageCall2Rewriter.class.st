Class {
	#name : #MessageCall2Rewriter,
	#superclass : #Object,
	#instVars : [
		'tmpVariables',
		'aMethod',
		'idx'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #initialization }
MessageCall2Rewriter class >> initializeFor: aMethodNode [
	^ self new initializeFor: aMethodNode 
]

{ #category : #adding }
MessageCall2Rewriter >> addTemporaryVariables [
	tmpVariables do: [ :tvar | aMethod body addTemporaryNamed: tvar ]
]

{ #category : #'as yet unclassified' }
MessageCall2Rewriter >> doYourJob [
	| tobechanged |
	tobechanged := OrderedCollection new.
	aMethod statements
		do: [ :st | 
			| transformedNodes  |
			transformedNodes := OrderedCollection new.
			st isCascade
				ifTrue: [ transformedNodes := self transformCascade: st ].
			st isMessage
				ifTrue: [ transformedNodes := self transformMessage: st ].
			st isAssignment
				ifTrue: [ transformedNodes := self transformAssignment: st ].
			transformedNodes
				ifNotEmpty: [ tobechanged
						addAll: (self transformNewNodes: transformedNodes insteadOf: st) ] ].
	self performSteps: tobechanged.
	self addTemporaryVariables
]

{ #category : #'as yet unclassified' }
MessageCall2Rewriter >> generateATemp [
	| tmp |
	tmp := 'tmp_' , GeneralHelper randomString , idx asString.
	idx := idx + 1.
	tmpVariables add: tmp.
	^ RBVariableNode named: tmp
]

{ #category : #initialization }
MessageCall2Rewriter >> initializeFor: aMethodNode [
	tmpVariables := OrderedCollection new.
	aMethod := aMethodNode.
	idx := 1
]

{ #category : #'as yet unclassified' }
MessageCall2Rewriter >> performSteps: steps [
	steps
		do: [ :step | 
			(step at: #op) = #add
				ifTrue: [ (step at: #node) parent: aMethod body.aMethod statements
						add: (step at: #node)
						afterIndex: (step at: #afterIndex).
					 ].
			(step at: #op) = #remove
				ifTrue: [ aMethod statements removeAt: (step at: #atIndex) ] ]
]

{ #category : #'as yet unclassified' }
MessageCall2Rewriter >> transformAssignment: st [
	| n |
	n := OrderedCollection new.
	st value isMessage
		ifTrue: [ self transformMessage: st value assignsTo: st variable ].
	st value isCascade
		ifTrue: [ self transformCascade: st value assignsTo: st variable ].
		^ n
]

{ #category : #'as yet unclassified' }
MessageCall2Rewriter >> transformCascade: st [
	| tmp |
	tmp := self generateATemp.
	^ self transformCascade: st assignsTo: tmp
]

{ #category : #'as yet unclassified' }
MessageCall2Rewriter >> transformCascade: st assignsTo: aVariable [
	| n |
	n := OrderedCollection new.
	st messages doWithIndex: [ :amsg :idx | idx = st messages size ifFalse: [n addAll: (self transformMessage: amsg)] ].
	n
		addAll: (self transformMessage: st messages last assignsTo: aVariable).
	^ n
]

{ #category : #'as yet unclassified' }
MessageCall2Rewriter >> transformMessage: st [
	| tmp |
	tmp := self generateATemp.
	^ self transformMessage: st assignsTo: tmp 
]

{ #category : #'as yet unclassified' }
MessageCall2Rewriter >> transformMessage: st assignsTo: aVariable [
	| n |
	n := OrderedCollection new.
	st receiver isVariable
		ifTrue: [ n add: (RBAssignmentNode variable: aVariable value: st) ].
	st receiver isCascade
		ifTrue: [  ].
	st receiver isMessage
		ifTrue: [ 
			| tmp |
			tmp := self generateATemp.
			n addAll: (self transformMessage: st receiver assignsTo: tmp).
			n add: (RBAssignmentNode variable: aVariable value: (RBMessageNode receiver: tmp selector: st selector arguments: st arguments))
			 ].
	^ n
]

{ #category : #'as yet unclassified' }
MessageCall2Rewriter >> transformNewNodes: transformedNodes insteadOf: st [
	| index steps |
	steps := OrderedCollection new.
	index := aMethod statements indexOf: st.
	transformedNodes
		reverseDo: [ :nd | 
			steps
				add:
					{(#op -> #add).
					(#node -> nd).
					(#afterIndex -> index)} asDictionary ].
	steps
		add:
			{(#op -> #remove).
			(#atIndex -> index)} asDictionary.
	^ steps
]
