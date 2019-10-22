Class {
	#name : #MuTalkMutationOperatorTest,
	#superclass : #TestCase,
	#instVars : [
		'testMethods',
		'instance'
	],
	#category : #'Amplification-Tests'
}

{ #category : #running }
MuTalkMutationOperatorTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	super setUp
]

{ #category : #tests }
MuTalkMutationOperatorTest >> testMutation [
	| result |
	testMethods := FakeTestcase methods select: [ :mtd | mtd selector beginsWith: 'test' ].
	result := OrderedCollection new.
	testMethods
		do: [ :atestMethod | 
			result
				add:
					atestMethod sourceCode
						-> (MuTalkMutationOperator new mutate: atestMethod sourceCode) ].
	"xzy := result at: 1.
	browser := GLMTabulator new.
	browser
		row: #navig;
		row: #diff.
	browser transmit to: #navig.
	browser transmit
		to: #diff;
		from: #navig;
		andShow: [ :a | 
			a diff
				display: [ :mutant | 
					{(GeneralHelper stripString: xzy key).
					(GeneralHelper stripString: mutant)} ] ].
	browser openOn: xzy value."
	self
		assert:
			(testMethods
				allSatisfy: [ :amtd | amtd methodNode body statements isNotEmpty ]).
	self
		assert:
			(result
				allSatisfy: [ :mtd | 
					mtd value
						allSatisfy: [ :amtd | (RBParser parseMethod: amtd) body statements isNotEmpty ] ]).
	self
		deny:
			(result
				anySatisfy: [ :org | 
					org value
						anySatisfy: [ :mut | 
							(GeneralHelper stripString: org key)
								= (GeneralHelper stripString: mut) ] ])
]
