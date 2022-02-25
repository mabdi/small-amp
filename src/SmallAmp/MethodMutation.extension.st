Extension { #name : #MethodMutation }

{ #category : #'*SmallAmp' }
MethodMutation >> asDictionaryObject [

	^ { 
		  (#id -> self smallAmpDecoratorText).
		  (#operatorDescription -> operator description).
		  (#operatorClass -> operator class name).
		  (#class -> originalClass name).
		  (#method -> originalMethod selector).
		  (#mutatedNode -> self mutatedNode formattedCode).
		  (#mutationStart -> self nodeToMutate start).
		  (#mutationEnd -> self nodeToMutate stop) } asDictionary
]

{ #category : #'*SmallAmp' }
MethodMutation >> smallAmpCommentText [
	^ String
		streamContents: [ :s | 
			s
				nextPutAll: '`';
				nextPutAll: self nodeToMutate formattedCode;
				nextPutAll: '` in method: `';
				nextPutAll: self originalClass name;
				nextPutAll: ' >> #';
				nextPutAll: self originalMethod selector;
				nextPutAll: '`' ]
]

{ #category : #'*SmallAmp' }
MethodMutation >> smallAmpDecoratorText [
	^ '#'
		join:
			{operator class name.
			self originalClass name.
			self originalMethod selector.
			nodeToMutate start.
			nodeToMutate stop}
]

{ #category : #'*SmallAmp' }
MethodMutation class >> smallAmpFromString: aMutantStringId [

	| parts operator theClass theSelector mutationStart mutationEnd theMethod mutants |
	self flag: #todo. "validity threat: if two mutants have similar start/stop, we will not detect. User the number of mutant in the future"
	parts := aMutantStringId splitOn: '#'.
	parts size = 5 ifFalse: [ ^ nil ].
	operator := (Smalltalk at: parts first asSymbol ifAbsent: [ ^ nil ])
		            new.
	(parts second endsWith: ' class') 
	ifTrue: [ 		
		theClass := Smalltalk at: (parts second allButLast: ' class' size) asSymbol ifAbsent: [ ^ nil ].
		theClass := theClass class] 
	ifFalse: [
		theClass := Smalltalk at: parts second asSymbol ifAbsent: [ ^ nil ].
	].
	theSelector := parts third asSymbol.
	mutationStart := (parts at: 4) asInteger.
	mutationEnd := (parts at: 5) asInteger.
	theMethod := theClass >> theSelector.
	mutants := operator mutationsFor: theMethod with: theMethod parseTree.
	^ mutants
		  detect: [ :m | 
			  m nodeToMutate start = mutationStart
			  & (m nodeToMutate stop = mutationEnd) ]
		  ifNone: [ ^ nil ]
]

{ #category : #'*SmallAmp' }
MethodMutation >> uninstallDeep [
	"UnInstall the mutant recompiling the original method into the class."

	MethodInstaller new
		installFromSource: originalMethod sourceCode
		in: originalClass
]
