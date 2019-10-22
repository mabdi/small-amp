Class {
	#name : #ShouldRaise,
	#superclass : #AssertTransform,
	#category : #'Amplification-Helpers'
}

{ #category : #running }
ShouldRaise >> assertPattern [
	^ '[ ``@aBlock value. false ]
		on: ``@anExceptionalEvent
		do: [ :ex | ex return: true ]'
]

{ #category : #running }
ShouldRaise >> findPattern [
	^ {'self should: ``@aBlock raise: ``@anExceptionalEvent' . 'self should: ``@aBlock raise: ``@anExceptionalEvent description: ``@qwe'}
]
