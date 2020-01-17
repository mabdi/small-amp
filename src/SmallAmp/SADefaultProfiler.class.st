Class {
	#name : #SADefaultProfiler,
	#superclass : #SAAbstractProfiler,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SADefaultProfiler >> installProxyOn: aMethod [
	| link |
	(self isItSafeToProxyTo: aMethod)
		ifFalse: [ ^ self ].
	link := SAProfilingProxy on: aMethod profiler: self.
	link install
]

{ #category : #'as yet unclassified' }
SADefaultProfiler >> isItSafeToProxyTo: aMethod [
	({#initialization} includes: aMethod protocol)
		ifTrue: [ ^ false ].
	^ true
]

{ #category : #'as yet unclassified' }
SADefaultProfiler >> objectAsSample: item [
	item isLiteral ifFalse: [ ^ nil ].
	^ item
]

{ #category : #'as yet unclassified' }
SADefaultProfiler >> preCall: aSelector with: anArray in: aReceiver [
	| sample |
	anArray
		withIndexDo: [ :item :index | 
			sample := self objectAsSample: item.
			profile
				at: '#' , aReceiver class name , '#' , aSelector , '#' , index
				put: item class.
			sample ifNotNil: 
			[samples
				at:
					'#' , aReceiver class name , '#' , aSelector , '#' , index
						, item class name
				put: sample] ]
]

{ #category : #'as yet unclassified' }
SADefaultProfiler >> profileClasses: listOfTargetClass byRunning: aTestSuite [
	listOfTargetClass do: [ :aTargetClass | aTargetClass methods do: [ :aMethod | self installProxyOn: aMethod ]].
	aTestSuite suite run.
	listOfTargetClass do: [ :aTargetClass |
	self uninstallProxyFor: aTargetClass
	]
]

{ #category : #'as yet unclassified' }
SADefaultProfiler >> uninstallProxyFor: aClass [
	"aClass removeSelector: #smallGenCallRecords:."

	SAProfilingProxy cureClass: aClass
]
