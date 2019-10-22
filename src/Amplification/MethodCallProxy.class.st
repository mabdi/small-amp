Class {
	#name : #MethodCallProxy,
	#superclass : #Object,
	#instVars : [
		'method',
		'uuid'
	],
	#classInstVars : [
		'history'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #accessing }
MethodCallProxy class >> buildFor: aMethod action: anAction [
	^ self basicNew initializeFor: aMethod action: anAction
]

{ #category : #'as yet unclassified' }
MethodCallProxy class >> fixClass: aClass [
	aClass methodDict
		keysAndValuesDo: [ :selector :mtd | 
			self fixMethod: mtd ]
]

{ #category : #'as yet unclassified' }
MethodCallProxy class >> fixMethod: aMethod [
	(aMethod isKindOf: self)
		ifTrue: [ aMethod  destroy	"aMethod methodClass methodDict
				at: aMethod selector
				put: aMethod method" ]
]

{ #category : #accessing }
MethodCallProxy class >> history [
	^ history ifNil: [ history := Dictionary new ]
]

{ #category : #'as yet unclassified' }
MethodCallProxy class >> log_install: uuid [
	| str |
	str := String
		streamContents:
			[ :stream | thisContext sender sender sender debugStack: 20 on: stream ].
	self history at: uuid put: str
]

{ #category : #'as yet unclassified' }
MethodCallProxy class >> log_uninstall: uuid [
	history removeKey: uuid ifAbsent: [  ]
]

{ #category : #cleanup }
MethodCallProxy class >> uninstallAll [
	self allInstances do: [ :p | p destroy ].
	self history removeAll
]

{ #category : #'as yet unclassified' }
MethodCallProxy >> destroy [
	self uninstallMethod: method
]

{ #category : #'changing suspended state' }
MethodCallProxy >> doesNotUnderstand: aMessage [
	"Messages not understood by myself are forwarded to the CompiledMethod I hold."

	^ method perform: aMessage selector withArguments: aMessage arguments
]

{ #category : #initialization }
MethodCallProxy >> initializeFor: aMethod [
	method := aMethod.
	uuid := UUIDGenerator new next asString.
	self installMethod: aMethod
]

{ #category : #'changing suspended state' }
MethodCallProxy >> installMethod: aMethod [
	"protocol: #'changing suspended state'"

	"Install myself instead of the CompiledMethod in the class holding it.
     This way, when sending a message to the CompiledMethod (to execute it for example)
     I am notified and I can remember that the method was run.
    "

	aMethod class = CompiledMethod
		ifFalse:
			[ self class fixMethod: aMethod	"Error new signal: 'Cannot install proxt. use FixClass'" ].
	
	self class log_install: uuid.
	aMethod methodClass methodDict at: aMethod selector put: self
]

{ #category : #'changing suspended state' }
MethodCallProxy >> run: aSelector with: anArray in: aReceiver [
	^ aReceiver withArgs: anArray executeMethod: method.
	
]

{ #category : #'as yet unclassified' }
MethodCallProxy >> uninstallMethod: aMethod [
	self class log_uninstall: uuid.
	aMethod methodClass methodDict at: aMethod selector put: aMethod
]
