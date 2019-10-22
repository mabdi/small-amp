Class {
	#name : #MethodProfile,
	#superclass : #Object,
	#instVars : [
		'before',
		'after'
	],
	#category : #'Amplification-Helpers'
}

{ #category : #adding }
MethodProfile >> addAfterArgs:args state: state returns: return [
	after add: ({#args-> args. #return-> return. #state -> state } asDictionary )
]

{ #category : #adding }
MethodProfile >> addBeforeArgs: args state: state [
	after
		add:
			{(#args -> args).
			(#state -> state)} asDictionary
]

{ #category : #initialization }
MethodProfile >> initialize [ 
	before := OrderedCollection new.
	after:= OrderedCollection new.
]
