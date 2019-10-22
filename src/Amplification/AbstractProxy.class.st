Class {
	#name : #AbstractProxy,
	#superclass : #Object,
	#instVars : [
		'proxies'
	],
	#category : #'Amplification-Core'
}

{ #category : #initialization }
AbstractProxy >> add: aMethod [
	| proxy |
	proxy := MethodCallProxy buildFor: aMethod action: self.
	proxies add: proxy
]

{ #category : #initialization }
AbstractProxy >> destroy [ 
	proxies do: [:p | p destroy ]
]

{ #category : #initialization }
AbstractProxy >> initialize [
	proxies := OrderedCollection new.
]

{ #category : #initialization }
AbstractProxy >> observeAfter: aSelector with: anArray in: aReceiver [
	self subclassResponsibility 
	"| id ctx lastctx |
	ctx := thisContext sender.
	lastctx := thisContext.
	[ ctx receiver class = MethodCallProxy ]
		whileTrue: [ lastctx := ctx.
			ctx := ctx sender ].
	id := ctx pc.
	self halt"

	"observer observe: anObject name: '' id: id"

	
]
