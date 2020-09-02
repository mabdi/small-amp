Class {
	#name : #SAProxyProfiler,
	#superclass : #SAAbstractProfiler,
	#instVars : [
		'links'
	],
	#category : #'SmallAmp-Core'
}

{ #category : #accessing }
SAProxyProfiler >> initialize [ 
	super initialize.
	links := OrderedCollection new
]

{ #category : #'as yet unclassified' }
SAProxyProfiler >> installProxyOn: aMethod [
	| link |
	(self isItSafeToProxyTo: aMethod)
		ifFalse: [ ^ self ].
	link := SAProfilingProxy on: aMethod profiler: self.
	link install.
	links add: link
]

{ #category : #'as yet unclassified' }
SAProxyProfiler >> isItSafeToProxyTo: aMethod [
	"({#initialization} includes: aMethod protocol)
		ifTrue: [ ^ false ]."
	^ true
]

{ #category : #'as yet unclassified' }
SAProxyProfiler >> objectAsSample: item [
	item isLiteral ifFalse: [ ^ nil ].
	^ item
]

{ #category : #'as yet unclassified' }
SAProxyProfiler >> preCall: aSelector with: anArray in: aReceiver [
	| sample |
	anArray
		withIndexDo: [ :item :index | 
			sample := self objectAsSample: item.
			profile
				at: '#' , aReceiver class name , '#' , aSelector , '#' , index asString
				put: item class.
			sample
				ifNotNil: [ | smaplesList |
					smaplesList := samples
						at:
							'#' , aReceiver class name , '#' , aSelector , '#' , index asString
								
						ifAbsentPut: [ Set new ].
					smaplesList add: sample copy ] ]
]

{ #category : #'as yet unclassified' }
SAProxyProfiler >> profileClasses: listOfTargetClass byRunning: aTestSuite [
	[ listOfTargetClass
		do:
			[ :aTargetClass | (aTargetClass methods,aTargetClass  class methods)  do: [ :aMethod | self installProxyOn: aMethod ] ].
	[ aTestSuite suite run ]
		valueWithin: config testRunTimeOut milliSeconds
		onTimeout: [ self error: 'Profiling timeout' ] ]
		ensure: [ listOfTargetClass
				do: [ :aTargetClass | self uninstallProxyFor: aTargetClass ] ]
]

{ #category : #'as yet unclassified' }
SAProxyProfiler >> uninstallProxyFor: aClass [
	"SAProfilingProxy cureClass: aClass"

	links do: [ :link | link uninstall ]	
]
