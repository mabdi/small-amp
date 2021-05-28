"
A SALiteralInputAmplifierTest is a test class for testing the behavior of SALiteralInputAmplifier
"
Class {
	#name : #SALiteralInputAmplifierTest,
	#superclass : #TestCase,
	#instVars : [
		'amplifier',
		'tempClasses'
	],
	#category : #'SmallAmp-Tests-Core'
}

{ #category : #running }
SALiteralInputAmplifierTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	amplifier := SALiteralInputAmplifier initializeWith: SAConfig dspot.
	tempClasses := OrderedCollection new.
]

{ #category : #running }
SALiteralInputAmplifierTest >> tearDown [ 
	tempClasses do: [ :cls | cls removeFromSystem  ]
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testArrayDouble [
	| res |
	res := SALiteralInputAmplifier new amplifyInputsSource: 
		 'foo |a| a set:{x}.b set:{x}'.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals: 'foo |a| a set:{}.b set:{x}'
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testBoolean [
	| res |
	res := SALiteralInputAmplifier new
		amplifyInputsSource: 'foo |a| a:=false'.
	self
		assert: res asString
		equals:
			'an OrderedCollection(''foo
	| a |
	a := true'')'
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testBoolean2 [
	| res codes cls item |
	cls := SAASTHelper new
		makeClassFrom: {'testDspotBoolean a:= true. b:= false'}
		instanceVars: 'a b'.
	tempClasses add: cls.
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
SALiteralInputAmplifierTest >> testByteArray [
	| res |
	res := SALiteralInputAmplifier new
		amplifyInputsSource: 'foo |a| a set:#[0 1 2 3]'.
	self assert: res size equals: 3.	"ignore children"
	self
		assertMethodSourceCode: (res at: 1) asString
		equals: 'foo |a| a set:#[]'
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testFloats2 [
	| res codes cls item |
	cls := SAASTHelper new
		makeClassFrom: {'testDspotFloat a:= 10.01 . b:= 3.14. c:=-0.01'}
		instanceVars: 'a b c'.
	tempClasses add: cls.item := SATestMethod
		with: (cls >> #testDspotFloat) sourceCode
		class: cls
		targets: FakeSmallBank.
	res := item inputAmplifyBy: amplifier.
	codes := res
		collect: [ :r | 
			r testMethod
				copyWithRegex: 'testDspot(.*)_L(\d+)'
				matchesReplacedWith: 'test' ].
	self assert: codes size >= 15.
	self
		assertMethodSourceCode: 'test a:= 9.01 . b:= 3.14. c:=-0.01'
		in: codes
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testFraction [
	| res |
	res := SALiteralInputAmplifier new
		amplifyInputsSource: 'foo |a| a:=2/3'.
	self
		assertMethodSourceCode:
			'foo |a| a:=1/3'
		in: res
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testInteger [
	| res |
	res := SALiteralInputAmplifier new
		amplifyInputsSource:  'foo |a| a:=10'.
	self
		assert: (res at: 1) asString
		equals:
			'foo
	| a |
	a := 11'
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testInteger2 [
	| res N |
	res := SALiteralInputAmplifier new
		amplifyInputsSource: 'foo |a b c| a:=10.b:=20.c:=30'.
	N := 9.	"+1 -1 *2 /2 *-1 0 intMax intMin rand"
	self assert: res size equals: 3 * N.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals:
			'foo
	| a b c |
	a := 11.
	b:=20.
	c:=30'
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testIntegerDouble [
	| res |
	res := SALiteralInputAmplifier new
		amplifyInputsSource:  'foo |a| a:=10. b:=10'.
	self
		assertMethodSourceCode: (res at: 1) asString
		equals: 'foo |a| a:=11. b:=10'
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testInts2 [
	| res codes cls item |
	cls := SAASTHelper new
		makeClassFrom: {'testDspotInts a:= 10. b:= 20. c:=29'}
		instanceVars: 'a b c'.tempClasses add: cls.
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
	self assert: codes size >= 15.
	self assertMethodSourceCode: 'test a:= 10. b:= 10. c:=29' in: codes
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testLiteralArray [
	| res |
	res := SALiteralInputAmplifier new
		amplifyInputsSource: 'foo |a| a set:#(10 11 12 13)'.
	self assert: res size equals: 4 * 9 + 4.	"continue to mutation in children"
	self
		assertMethodSourceCode: 'foo |a| a set:#()' 
		in: res 
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testString [
	| res |
	res := SALiteralInputAmplifier new
		amplifyInputsSource: 'foo |a| a:=''Hello World'''.
	self
		assert: (res at: 1) asString
		equals:
			'foo
	| a |
	a := '''''
]

{ #category : #tests }
SALiteralInputAmplifierTest >> testString2 [
	| res codes cls item |
	cls := SAASTHelper new
		makeClassFrom: {'testDspotString a:= ''dspot'''}
		instanceVars: 'a'.
		tempClasses add: cls.
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
	self assert: codes size equals: 5
]
