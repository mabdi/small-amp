Extension { #name : #RBProgramNode }

{ #category : #'*SmallAmp-DrTests' }
RBProgramNode >> asResultForDrTest [
	^ DTTestLeaf content: self
]

{ #category : #'*SmallAmp-DrTests' }
RBProgramNode >> drTestsBrowse [
	| text browser |
	text := self methodNode sourceCode asText.
	text
		addAttribute: TextEmphasis bold from: self start to: self stop;
		addAttribute: (TextColor color: Color red)
			from: self start
			to: self stop.
	SpTextPresenter new
		openWithSpec;
		text: text
]

{ #category : #'*SmallAmp-DrTests' }
RBProgramNode >> drTestsName [
	^ self printString
]
