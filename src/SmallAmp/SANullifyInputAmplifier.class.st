Class {
	#name : #SANullifyInputAmplifier,
	#superclass : #SAAbstractInputAmplifier,
	#category : #'SmallAmp-Core'
}

{ #category : #removing }
SANullifyInputAmplifier >> amplifyInputs [
	| aMethodAST results |
	aMethodAST := SAASTHelper new
		parsedMethodFrom: testMethodModel testMethod.
	results := self nullifyMessageNodes: aMethodAST.
	^ results collect: #formattedCode
]

{ #category : #'as yet unclassified' }
SANullifyInputAmplifier >> namingPrefix [
	^ 'N'
]

{ #category : #'as yet unclassified' }
SANullifyInputAmplifier >> nilNode [
	^ RBLiteralValueNode value: nil
]

{ #category : #'as yet unclassified' }
SANullifyInputAmplifier >> nullifyMessageNodes: aMethodNode [
	| result msgs newCode |
	msgs := aMethodNode copy allChildren select: #isMessage.
	result := OrderedCollection new.
	msgs do: [ :msg | 
		msg arguments doWithIndex: 
			[ :arg :index | 
				newCode := msg copy. 
				newCode arguments at: index put: self nilNode.
				result add: 
					(RBParseTreeRewriter replace: msg formattedCode with: newCode formattedCode in: aMethodNode copy) ]. 
	].
   ^ result
]

{ #category : #'as yet unclassified' }
SANullifyInputAmplifier >> selectNode: node [
	(node parent isMessageSend and: [node parent arguments includes: node]) 
		ifTrue: [ ^ true ].
	^ false
]
