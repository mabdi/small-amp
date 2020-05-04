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
SAMethodNormalizingRewriter >> extractVariableFrom: aNode [
	aNode isAssignment
		ifTrue: [ ^ aNode variable ].
	aNode isSelfOrSuper
		ifTrue: [ ^ self generateATemp ].
	(aNode isVariable and: [ aNode name first isUppercase not ])
		ifTrue: [ ^ aNode ].
	^ self generateATemp
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> generateATemp [
	| tmp |
	tmp := 'tmp_' , self randomString , idx asString.
	idx := idx + 1.
	tmpVariables add: tmp.
	^ RBVariableNode named: tmp
]

{ #category : #initialization }
SAMethodNormalizingRewriter >> initialize [
	idx := 1.
	tmpVariables := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> normalizeAssignment: anAssignmentNode assignTo: assignTo [
	" dont care about assignTo value yet "

	| result |
	anAssignmentNode value isAssignment
		ifTrue: [ result := anAssignmentNode value
				smallAmpNormalizeWith: self
				assignTo: anAssignmentNode value variable.
			result
				add:
					(RBAssignmentNode
						variable: anAssignmentNode variable
						value: anAssignmentNode value variable).
					^ result ].
	result := anAssignmentNode value
		smallAmpNormalizeWith: self
		assignTo: anAssignmentNode variable.
	result
		ifEmpty: [ result
				add:
					(RBAssignmentNode
						variable: anAssignmentNode variable
						value: anAssignmentNode value) ].
	^ result
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> normalizeCascadeNode: aCascadeNode assignTo: assignTo [
	| receiver result receiverVar aVariable tmpMsg |
	result := OrderedCollection new.
	receiver := aCascadeNode messages anyOne receiver.
	receiverVar := receiver.
	({receiverVar isMessage.
	receiverVar isCascade.
	receiverVar isAssignment} anySatisfy: #value)
		ifTrue: [ receiverVar := self extractVariableFrom: receiverVar ].
	receiverVar name first isUppercase
		ifTrue: [ receiverVar := self generateATemp ].
	aVariable := assignTo ifNil: [ receiverVar ] ifNotNil: [ assignTo ].
	"tmp := self extractVariableFrom: receiver."
	
	result
		addAll: (receiver smallAmpNormalizeWith: self assignTo: receiverVar).
	aCascadeNode messages
		doWithIndex: [ :amsg :i | 
			tmpMsg := amsg copy.
			receiver isVariable ifTrue: [ tmpMsg receiver: receiver ] ifFalse: [ tmpMsg receiver: receiverVar ]
			.
			i = aCascadeNode messages size
				ifTrue: [ result
						addAll: (tmpMsg smallAmpNormalizeWith: self assignTo: aVariable) ]
				ifFalse: [ result addAll: (tmpMsg smallAmpNormalizeWith: self assignTo: nil) ] ].
	^ result
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> normalizeMessageNode: aMessageNode assignTo: assignTo [
	| aVariable result tmp |
	tmp := aMessageNode receiver.
	({tmp isMessage. tmp isCascade. tmp isAssignment  } anySatisfy: #value)
		ifTrue: [ tmp := self extractVariableFrom: tmp ].
	aVariable := assignTo
		ifNil: [ self generateATemp ]
		ifNotNil: [ assignTo ].
	result := OrderedCollection new.
	result
		addAll: (aMessageNode receiver smallAmpNormalizeWith: self assignTo: tmp).
	"result ifEmpty: [ tmp := aMessageNode receiver ]."
	result
		add:
			(RBAssignmentNode
				variable: aVariable
				value:
					(RBMessageNode
						receiver: tmp
						selector: aMessageNode selector
						arguments: aMessageNode arguments)).
	^ result
]

{ #category : #'as yet unclassified' }
SAMethodNormalizingRewriter >> normalizeNode: aNode assignTo: assignTo [
	^ OrderedCollection new
	"assignTo ifNil: [ self error: 'assignTo is nil' ].
	^ OrderedCollection
		with: (RBAssignmentNode variable: assignTo value: aNode copy)"
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
			transformedNodes := aStatement smallAmpNormalizeWith: self assignTo: nil.
			transformedNodes
				ifNotEmpty: [ toBeChanged
						add: (self transformNewNodes: transformedNodes insteadOf: aStatement) ] ].
	self performSteps: toBeChanged.
	self addTemporaryVariables
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
	aMethodAST := aTestTestAST
]
