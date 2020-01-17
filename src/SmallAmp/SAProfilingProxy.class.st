"
I am a copy of class SGProxy. This comment is copied from there, and might not be entirely accurate

Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  State a one line summary. For example, ""I represent a paragraph of text"".

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	action:		<Object>
	method:		<Object>


    Implementation Points
"
Class {
	#name : #SAProfilingProxy,
	#superclass : #ProtoObject,
	#instVars : [
		'method',
		'action',
		'profiler'
	],
	#category : #'SmallAmp-Helpers'
}

{ #category : #curing }
SAProfilingProxy class >> cureClass: aClass [
	aClass methodDict values
		select: [ :x | x class = self ]
		thenDo: [ :x | self cureMethod: x ]
]

{ #category : #curing }
SAProfilingProxy class >> cureMethod: aMethod [
	| m |
	m := aMethod.
	[ m method class = self ] whileTrue: [ m := m method ].
	m uninstall
]

{ #category : #'as yet unclassified' }
SAProfilingProxy class >> on: aCompiledMethod profiler: action [
	"Initialize the method tracer on aCompiledMethod and returns the method tracer.
     Do not install the tracer. You need to explicitely call #install on the instance returned to install it.
    "

	^ self basicNew initializeOn: aCompiledMethod profiler: action
]

{ #category : #initialization }
SAProfilingProxy >> doesNotUnderstand: aMessage [
	"Messages not understood by myself are forwarded to the CompiledMethod I hold."

	^ method perform: aMessage selector withArguments: aMessage arguments
]

{ #category : #printing }
SAProfilingProxy >> gtDisplayString [
	^ self class name
]

{ #category : #initialization }
SAProfilingProxy >> initializeOn: aCompiledMethod profiler: anObject [
	aCompiledMethod class = CompiledMethod
		ifFalse: [ Error new signal: 'cannot install proxy on other object' ].
	profiler := anObject.
	method := aCompiledMethod
]

{ #category : #initialization }
SAProfilingProxy >> install [
	"Install myself instead of the CompiledMethod in the class holding it.
     This way, when sending a message to the CompiledMethod (to execute it for example)
     I am notified and I can remember that the method was run.
    "

	method methodClass methodDict at: method selector put: self
]

{ #category : #initialization }
SAProfilingProxy >> method [
	^ method
]

{ #category : #printing }
SAProfilingProxy >> printOn: aStream [
	aStream nextPutAll: self class name
]

{ #category : #initialization }
SAProfilingProxy >> run: aSelector with: anArray in: aReceiver [
	"Log the fact that the method was called and execute it."

	| result |
	profiler preCall: aSelector with: anArray in: aReceiver.
	result := aReceiver withArgs: anArray executeMethod: method.
	^ result
]

{ #category : #initialization }
SAProfilingProxy >> uninstall [
    "Put the CompiledMethod I replaced back to its place.
     After this method has been executed, I do not receive CompiledMethod's
     messages before forwarding them to it anymore.
    "
    method methodClass methodDict
         at: method selector
         put: method
]
