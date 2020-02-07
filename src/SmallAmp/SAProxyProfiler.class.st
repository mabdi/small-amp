Class {
	#name : #SAProxyProfiler,
	#superclass : #SAAbstractProfiler,
	#category : #'SmallAmp-Core'
}

{ #category : #'as yet unclassified' }
SAProxyProfiler >> installProxyOn: aMethod [
	| link |
	(self isItSafeToProxyTo: aMethod)
		ifFalse: [ ^ self ].
	link := SAProfilingProxy on: aMethod profiler: self.
	link install
]

{ #category : #'as yet unclassified' }
SAProxyProfiler >> isItSafeToProxyTo: aMethod [
	({#initialization} includes: aMethod protocol)
		ifTrue: [ ^ false ].
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
					smaplesList add: sample ] ]
]

{ #category : #'as yet unclassified' }
SAProxyProfiler >> profileClasses: listOfTargetClass byRunning: aTestSuite [
	[ listOfTargetClass
		do:
			[ :aTargetClass | aTargetClass methods do: [ :aMethod | self installProxyOn: aMethod ] ].
	aTestSuite suite run. ] ensure: 
	
	[
	listOfTargetClass
		do: [ :aTargetClass | self uninstallProxyFor: aTargetClass ]]
]

{ #category : #'as yet unclassified' }
SAProxyProfiler >> uninstallProxyFor: aClass [
	"aClass removeSelector: #smallGenCallRecords:."

	SAProfilingProxy cureClass: aClass
]
