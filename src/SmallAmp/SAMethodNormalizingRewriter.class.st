Class {
	#name : #SAMethodNormalizingRewriter,
	#superclass : #Object,
	#instVars : [
		'tmpVariables',
		'idx',
		'aMethodAST'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #'instance creation' }
SAMethodNormalizingRewriter class >> runWith: aTestTestAST [
	^ self new
		  with: aTestTestAST;
		  run;
		  yourself
]

{ #category : #initialization }
SAMethodNormalizingRewriter class >> with: aTestTestAST [
	^ self new initializeFor: aTestTestAST
]

{ #category : #adding }
SAMethodNormalizingRewriter >> addTemporaryVariables [
	tmpVariables do: [ :tvar | aMethodAST body addTemporaryNamed: tvar ]
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> generateATemp [
	| tmp |
	tmp := 'tmp_' , self randomString , idx asString.
	idx := idx + 1.
	tmpVariables add: tmp.
	^ RBVariableNode named: tmp
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> performSteps: changes [
	changes
		reverseDo: [ :aChangeList |
			
			aChangeList
				do: [ :aChange | 
					
					(aChange at: #op) = #add
						ifTrue: [ (aChange at: #node) parent: aMethodAST body.
							aMethodAST statements
								add: (aChange at: #node)
								afterIndex: (aChange at: #afterIndex) ].
					(aChange at: #op) = #remove
						ifTrue: [ aMethodAST statements removeAt: (aChange at: #atIndex) ] ] ]
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> randomString [
	| string |
	string := String streamContents: [ :stream | 
		          Character alphabet putOn: stream.
		          Character alphabet asUppercase putOn: stream.
		          '0123456789' putOn: stream ].
	^ (String new: 10) collect: [ :each | string atRandom ]
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> run [
	| toBeChanged |
	toBeChanged := OrderedCollection new.
	aMethodAST statements
		do: [ :aStatement | 
			| transformedNodes |
			transformedNodes := OrderedCollection new.
			aStatement isCascade
				ifTrue: [ transformedNodes := self transformCascade: aStatement ].
			aStatement isMessage
				ifTrue: [ transformedNodes := self transformMessage: aStatement ].
			aStatement isAssignment
				ifTrue: [ transformedNodes := self transformAssignment: aStatement ].
			transformedNodes
				ifNotEmpty: [ toBeChanged
						add: (self transformNewNodes: transformedNodes insteadOf: aStatement) ] ].
	
	self performSteps: toBeChanged.
	self addTemporaryVariables
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> transformAssignment: anAssignmentNode [
	| result |
	result := OrderedCollection new.
	anAssignmentNode value isMessage
		ifTrue: [ result addAll: (self transformMessage: anAssignmentNode value assignsTo: anAssignmentNode variable) ].
	anAssignmentNode value isCascade
		ifTrue: [ result addAll: (self transformCascade: anAssignmentNode value assignsTo: anAssignmentNode variable) ].
		^ result
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> transformCascade: aCascadeNode [
	| var receiver |
	receiver := aCascadeNode messages anyOne receiver.
	var := receiver isVariable
		ifTrue: [ receiver ]
		ifFalse: [self generateATemp].
	^ self transformCascade: aCascadeNode assignsTo: var
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> transformCascade: aCascadeNode assignsTo: aVariable [
	| result receiver |
	result := OrderedCollection new.
	receiver := aCascadeNode messages anyOne receiver.
	receiver isCascade
		ifTrue: [ result
				addAll: (self transformCascade: receiver assignsTo: aVariable) ].
	receiver isMessage
		ifTrue: [ result
				addAll: (self transformMessage: receiver assignsTo: aVariable) ].
	aCascadeNode messages
		doWithIndex: [ :amsg :i | |tmp| tmp := amsg copy. tmp receiver: aVariable. result addAll: (self transformMessage: tmp) ].
	^ result
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> transformMessage: aMessageNode [
	| tmp |
	tmp := self generateATemp.
	^ self transformMessage: aMessageNode assignsTo: tmp 
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> transformMessage: aMessageNode assignsTo: aVariable [
	| result |
	result := OrderedCollection new.
	aMessageNode receiver isVariable
		ifTrue: [ result
				add: (RBAssignmentNode variable: aVariable value: aMessageNode copy) ].
	aMessageNode receiver isCascade
		ifTrue: [  ].
	aMessageNode receiver isMessage
		ifTrue: [ | tmp |
			tmp := self generateATemp.
			result
				addAll: (self transformMessage: aMessageNode receiver assignsTo: tmp).
			result
				add:
					(RBAssignmentNode
						variable: aVariable
						value:
							(RBMessageNode
								receiver: tmp
								selector: aMessageNode selector
								arguments: aMessageNode arguments)) ].
	^ result
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> transformNewNodes: transformedNodes insteadOf: st [
	| index steps |
	steps := OrderedCollection new.
	index := aMethodAST statements identityIndexOf: st.
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

{ #category : #initialization }
SAMethodNormalizingRewriter >> with: aTestTestAST [
	tmpVariables := OrderedCollection new.
	aMethodAST := aTestTestAST.
	idx := 1
]
