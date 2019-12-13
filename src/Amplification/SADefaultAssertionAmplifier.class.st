Class {
	#name : #SADefaultAssertionAmplifier,
	#superclass : #SAAbstractAssertionAmplifier,
	#category : #'Amplification-Core'
}

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> amplifyAssertions [
	| generatedClass aMethodAST sourceCodeWithoutObservers sourceCodeWithAssertions |
	aMethodAST := self astHelper parsedMethodFrom:
		              testMethodModel testMethod.
	self normalizeMethod: aMethodAST.
	sourceCodeWithoutObservers := aMethodAST formattedCode.
	self insertObservers: aMethodAST.
	generatedClass := self
		                  buildANewClassFor: aMethodAST
		                  basedOn: testMethodModel testClass.
	generatedClass suite run.
	self ignoreFlakyValuesIn: generatedClass.
	sourceCodeWithAssertions := self
		                            insertAsserts:
		                            sourceCodeWithoutObservers
		                            using: generatedClass observer.
	self astHelper removeClass: generatedClass source: self class name.
	^ sourceCodeWithAssertions
]

{ #category : #accessing }
SADefaultAssertionAmplifier >> astHelper [
	^ SAASTHelper new
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> buildANewClassFor: aMethod basedOn: aClass [
	| generatedClass |
	generatedClass := self astHelper
		                  buildTestClassWith: {  }
		                  using: aClass.
	generatedClass class addInstVarNamed: 'observer'.
	generatedClass class compile:
		'observer ^ observer ifNil: [ observer := SAObserver newForTarget: ', testMethodModel testTargets asString ,' ]'.
	generatedClass compile: aMethod formattedCode.
	^ generatedClass
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> buildAsserts: anObserver methodName: selector [
	^ anObserver history collect: [ :observation | 
		  | asserts unserializer generateAsserts |
		  generateAsserts := true.
		  observation
			  at: #equalReceiver
			  ifPresent: [ :equalReceiver | 
			  equalReceiver ifTrue: [ generateAsserts := false ] ].
		  observation at: #class ifAbsent: [ generateAsserts := false ].
		  asserts := OrderedCollection new.
		  observation at: #exceptionClass ifPresent: [ :exceptionClass | 
			  asserts := { (ErrorSerializer makeAssertError: exceptionClass) }.
			  generateAsserts := false ].
		  observation at: #timeOutLimit ifPresent: [ :timeOutLimit | 
			  asserts := { (AbstractSerializer makeAssertTimeOut: timeOutLimit) }.
			  generateAsserts := false ].
		  generateAsserts ifTrue: [ 
			  unserializer := SerializerFactory getUnserializer: observation.
			  asserts := unserializer makeAssertsBasedOnMemory:
				             anObserver memory ].
		  asserts doWithIndex: [ :assrt :index | 
			  assrt arguments
				  detect: [ :obj | 
					  obj class = RBLiteralValueNode and: [ obj value = 'smallAmp' ] ]
				  ifFound: [ :obj | 
					  obj
						  value:
							  selector asString , ':' , (observation at: #id) asString
							  , '.' , index asString
						  start: 0
						  stop: -1 ] ].
		  (observation at: #id) -> asserts ]
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> flackyTestRepeat [
	^ 3
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> ignoreFlakyValuesIn: generatedClass [
	self flackyTestRepeat timesRepeat: [ 
		generatedClass observer resetFlakyDetection.
		generatedClass suite run.
		generatedClass observer checkFlaky ] "Flaky detection"
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> insertAsserts: aMethodSrc using: anObserver [
	| aMethod newAsserts |
	aMethod := self astHelper parsedMethodFrom: aMethodSrc.
	newAsserts := self
		              buildAsserts: anObserver
		              methodName: aMethod selector.
	newAsserts reverse do: [ :pair | 
		pair value reverse do: [ :assrt | 
			| enclouse |
			enclouse := false.
			assrt selector = #should:raise:description: ifTrue: [ 
				enclouse := true ].
			assrt selector = #should:notTakeMoreThan:description: ifTrue: [ 
				enclouse := true ].
			assrt selector = #should:takeMoreThan:description: ifTrue: [ 
				enclouse := true ].
			enclouse
				ifTrue: [ 
					| msg block |
					msg := aMethod body statements at: pair key.
					block := RBBlockNode body: (RBSequenceNode statements: { msg }).
					assrt arguments at: 1 put: block.
					aMethod body statements at: pair key put: assrt "] " ]
				ifFalse: [ 
				aMethod body statements add: assrt afterIndex: pair key ] ] ].
	^ aMethod formattedCode
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> insertObservers: aMethodAST [
	SAObserverInsertingRewriter runWith: aMethodAST
]

{ #category : #'as yet unclassified' }
SADefaultAssertionAmplifier >> normalizeMethod: aMethodAST [
	SAMethodNormalizingRewriter runWith: aMethodAST
]
