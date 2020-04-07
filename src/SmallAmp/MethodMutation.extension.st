Extension { #name : #MethodMutation }

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
