Class {
	#name : #FakeSmallBankTestAmpResult,
	#superclass : #SmallBankTest,
	#category : #'SmallAmp-Tests-Fakes'
}

{ #category : #'as yet unclassified' }
FakeSmallBankTestAmpResult class >> allTestSelectors [
		| answer |
		answer := Set withAll: self testSelectors.
		answer addAll: self superclass allTestSelectors.
		^ answer asSortedCollection asOrderedCollection
]

{ #category : #'as yet unclassified' }
FakeSmallBankTestAmpResult class >> defaultTimeLimit [
	^ 3 seconds 
]

{ #category : #'as yet unclassified' }
FakeSmallBankTestAmpResult class >> smallAmpTargetClasses [
	^ self superclass smallAmpTargetClasses
]

{ #category : #'as yet unclassified' }
FakeSmallBankTestAmpResult >> testDeposit_amp [

	"SmallAmp has derived this test from `SmallBankTest>>#testDeposit` by regenerating its assertions.
	This test can cover this part:
	*	In `SmallBank>> #rand` from 28 to 50:
		Operation: RemoveCaretOperator
		Code snippet: `^ (1 to: 1000) atRandom`
		Dynamic state: nil
		Mutant id: RemoveCaretOperator#SmallBank#rand#28#50
"

	<madeBySmallAmp>
	| b |
	b := SmallBank new.
	self assert: b rand class equals: SmallInteger.
	b
		deposit: 10;
		deposit: 100
]

{ #category : #'as yet unclassified' }
FakeSmallBankTestAmpResult >> testDeposit_amp_A1 [

	"SmallAmp has derived this test from `SmallBankTest>>#testDeposit` by applying some transformations and regenerating its assertions.
	This test can cover this part:
	*	In `SmallBank>> #withdraw:` from 19 to 92:
		Operation: ReplaceIfTrueReceiverWithTrueOperator
		Code snippet: `balance >= amount ifTrue: [ 
	balance := balance - amount.
	^ true ]`
		Dynamic state: {#balance->0. #amount->30}
		Mutant id: ReplaceIfTrueReceiverWithTrueOperator#SmallBank#withdraw:#19#92
"

	<madeBySmallAmp>
	| b aBoolean |
	b := SmallBank new.
	aBoolean := b withdraw: 30.
	self
		assert: b balance equals: 0;
		deny: aBoolean.
	b
		deposit: 10;
		deposit: 100
]

{ #category : #'as yet unclassified' }
FakeSmallBankTestAmpResult >> testWithdraw_amp_U0 [

	"SmallAmp has derived this test from `SmallBankTest>>#testWithdraw` by applying some transformations and regenerating its assertions.
	This test can cover this part:
	*	In `SmallBank>> #withdraw:` from 19 to 35:
		Operation: ReplaceGreaterOrEqualWithGreaterMutantOperator
		Code snippet: `balance >= amount`
		Dynamic state: {#balance->100. #amount->100}
		Mutant id: ReplaceGreaterOrEqualWithGreaterMutantOperator#SmallBank#withdraw:#19#35
"

	<madeBySmallAmp>
	| b |
	b := FakeSmallBank new.
	b
		deposit: 100;
		withdraw: 100.
	self assert: b balance equals: 0
]
