Extension { #name : #MethodMutation }

{ #category : #'*SmallAmp' }
MethodMutation >> asDictionaryObject [
	^ {(#operatorDescription -> operator description).
	(#operatorClass -> operator class name).
	(#class -> originalClass name).
	(#method -> originalMethod selector).
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
