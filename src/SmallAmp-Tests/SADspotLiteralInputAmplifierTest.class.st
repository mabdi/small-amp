"
A SADspotLiteralInputAmplifierTest is a test class for testing the behavior of SADspotLiteralInputAmplifier
"
Class {
	#name : #SADspotLiteralInputAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'amplifier'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #running }
SADspotLiteralInputAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	amplifier := SADspotLiteralInputAmplifier initializeWith: SAConfig dspot 
]

{ #category : #tests }
SADspotLiteralInputAmplifierTest >> testBoolean [
	| res codes cls item |
	cls := SAASTHelper new
		makeClassFrom: {'testDspotBoolean a:= true. b:= false'}
		instanceVars: 'a b'.
	item := SATestMethod
		with: (cls >> #testDspotBoolean) sourceCode
		class: cls
		targets: FakeSmallBank.
	res := item inputAmplifyBy: amplifier.
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testDspot(.*)_L(\d+)'
				matchesReplacedWith: 'test' ].
	codes := codes sort.
	self assert: codes size equals: 2.
	self
		assertMethodSourceCode: (codes at: 1) asString
		equals: 'test a:= false. b:= false'
]

{ #category : #tests }
SADspotLiteralInputAmplifierTest >> testFloats [
	| res codes cls item |
	cls := SAASTHelper new
		makeClassFrom: {'testDspotFloat a:= 10.01 . b:= 3.14. c:=-0.01'}
		instanceVars: 'a b c'.
	item := SATestMethod
		with: (cls >> #testDspotFloat) sourceCode
		class: cls
		targets: FakeSmallBank.
	res := item inputAmplifyBy: amplifier.
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testDspot(.*)_L(\d+)'
				matchesReplacedWith: 'test' ].
	self assert: codes size equals: 15.
	self
		assertMethodSourceCode: (codes at: 1) asString
		equals:
			'test a:= 9.01 . b:= 3.14. c:=-0.01'
]

{ #category : #tests }
SADspotLiteralInputAmplifierTest >> testInts [
	| res codes cls item |
	cls := SAASTHelper new
		makeClassFrom:
			{'testDspotInts a:= 10. b:= 20. c:=29'}
		instanceVars: 'a b c'.
	item := SATestMethod
		with: (cls >> #testDspotInts) sourceCode
		class: cls
		targets: FakeSmallBank.
	res := item inputAmplifyBy: amplifier.
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testDspot(.*)_L(\d+)'
				matchesReplacedWith: 'test' ].
	codes := codes sort.
	self assert: codes size equals: 15.
	self
		assertMethodSourceCode: (codes at: 1) asString
		equals:
			'test a:= 10. b:= 10. c:=29'
]

{ #category : #tests }
SADspotLiteralInputAmplifierTest >> testString [
	| res codes cls item |
	cls := SAASTHelper new
		makeClassFrom: {'testDspotString a:= ''dspot'''}
		instanceVars: 'a'.
	item := SATestMethod
		with: (cls >> #testDspotString) sourceCode
		class: cls
		targets: FakeSmallBank.
	res := item inputAmplifyBy: amplifier.
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testDspot(.*)_L(\d+)'
				matchesReplacedWith: 'test' ].
	codes := codes sort.
	self
		assert: codes size
		equals: 4
]
