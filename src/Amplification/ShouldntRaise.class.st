Class {
	#name : #ShouldntRaise,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
ShouldntRaise >> assertPattern [
	^ '([ ``@aBlock value. false ]
		on: ``@anExceptionalEvent
		do: [ :ex | ex return: true ]) not'
]

{ #category : #running }
ShouldntRaise >> findPattern [
	^ {'self shouldnt: ``@aBlock raise: ``@anExceptionalEvent'.
	'self shouldnt: ``@aBlock raise: ``@anExceptionalEvent description: ``@qwe'}
]
