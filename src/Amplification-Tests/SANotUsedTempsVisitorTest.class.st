"
A SANotUsedTempsVisitorTest is a test class for testing the behavior of SANotUsedTempsVisitor
"
Class {
	#name : #SANotUsedTempsVisitorTest,
	#superclass : #TestCase,
	#category : #'Amplification-Tests-Helpers'
}

{ #category : #tests }
SANotUsedTempsVisitorTest >> testDetectUsedVariable [
	| visitor mtd |
	mtd := SAASTHelper new parsedMethodFrom: 'helloWorld 
		| used notUsed |
		used := 3.
		used + 3
	'.
	visitor := SANotUsedTempsVisitor new.
	visitor tmp_var: 'used'.
	mtd acceptVisitor: visitor.
	self assert: visitor used
]

{ #category : #tests }
SANotUsedTempsVisitorTest >> testDetectUsedVariableObject [
	| visitor mtd |
	mtd := SAASTHelper new parsedMethodFrom: 'helloWorld 
		| used notUsed |
		used := Array new.
		used size
	'.
	visitor := SANotUsedTempsVisitor new.
	visitor tmp_var: 'used'.
	mtd acceptVisitor: visitor.
	self assert: visitor used
]

{ #category : #tests }
SANotUsedTempsVisitorTest >> testDetectUselessVariable [
	| visitor mtd |
	mtd := SAASTHelper new parsedMethodFrom: 'helloWorld 
		| used notUsed |
		used := Array new.
		used size
	'.
	visitor := SANotUsedTempsVisitor new.
	visitor tmp_var: 'notUsed'.
	mtd acceptVisitor: visitor.
	self deny: visitor used
]

{ #category : #tests }
SANotUsedTempsVisitorTest >> testDetectUselessVariableJustWrite [
	| visitor mtd |
	mtd := SAASTHelper new parsedMethodFrom: 'helloWorld 
		| used notUsed |
		notUsed := 10.
		used := Array new.
		used size
	'.
	visitor := SANotUsedTempsVisitor new.
	visitor tmp_var: 'notUsed'.
	mtd acceptVisitor: visitor.
	self deny: visitor used
]
