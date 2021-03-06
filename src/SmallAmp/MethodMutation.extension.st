Extension { #name : #MethodMutation }

{ #category : #'*SmallAmp' }
MethodMutation >> asDictionaryObject [
	^ {(#operatorDescription -> operator description).
	(#operatorClass -> operator class name).
	(#class -> originalClass name).
	(#method -> originalMethod selector).
	(#mutatedNode -> self mutatedNode formattedCode).
	(#mutationStart -> self nodeToMutate start).
	(#mutationEnd -> self nodeToMutate stop)} asDictionary
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
MethodMutation >> uninstallDeep [
	"UnInstall the mutant recompiling the original method into the class."

	MethodInstaller new
		installFromSource: originalMethod sourceCode
		in: originalClass
]
