Class {
	#name : #EvolutionaryAmpliferTest,
	#superclass : #TestCase,
	#category : #'Amplification-Tests'
}

{ #category : #'as yet unclassified' }
EvolutionaryAmpliferTest >> mutalkTarget: aClass testSuite: aTestSuite [
	| analysis1 |
	analysis1 := MutationTestingAnalysis
		testCasesFrom: aTestSuite
		mutating: aClass
		using: MutantOperator contents
		with: AllTestsMethodsRunningMutantEvaluationStrategy new.
	analysis1 run.
	^ analysis1
]

{ #category : #tests }
EvolutionaryAmpliferTest >> testRun [
	| newTest run1 run2 |
	newTest := (Amplification
		initializeWithTests:
			{(#testTargets -> {SmallBank}).
			(#testClass -> SmallBankTest).
			(#GAIteration -> 2)} asDictionary) launch.
	run1 := self mutalkTarget: {SmallBank} testSuite: {SmallBankTest}.
	run2 := self mutalkTarget: {SmallBank} testSuite: {newTest}.
	self
		assert: run2 generalResult mutationScore > run1 generalResult mutationScore
]

{ #category : #tests }
EvolutionaryAmpliferTest >> testRunArray2DTest [
	(Amplification
		initializeWithTests:
			{(#testTargets -> {Array2D}).
			(#testClass -> Array2DTest).
			(#GAIteration -> 2)} asDictionary) launch
]

{ #category : #tests }
EvolutionaryAmpliferTest >> testRunN100 [
	| run1 newTest run2 |
	newTest := (Amplification
		initializeWithTests:
			{(#testTargets -> {SmallBank}).
			(#testClass -> SmallBankTest).
			(#GAIteration -> 100)} asDictionary) launch.
	run1 := self mutalkTarget: {SmallBank} testSuite: {SmallBankTest}.
	run2 := self mutalkTarget: {SmallBank} testSuite: {newTest}.
	self
		assert: run2 generalResult mutationScore > run1 generalResult mutationScore
]

{ #category : #tests }
EvolutionaryAmpliferTest >> testRunRoassel3_RSView [

	| newTest run1 run2 |
	newTest := (Amplification
		initializeWithTests:
			{(#testTargets -> {RSView}).
			(#testClass -> RSViewTest).
			(#GAIteration -> 2)} asDictionary) launch.
	run1 := self mutalkTarget: {RSView} testSuite: {RSViewTest}.
	run2 := self mutalkTarget: {RSView} testSuite: {newTest}.
	self
		assert: run2 generalResult mutationScore > run1 generalResult mutationScore
]

{ #category : #tests }
EvolutionaryAmpliferTest >> testRunRoassel3_TSSequentialAnimation [
	| newTest run1 run2 |
	newTest := (Amplification
		initializeWithTests:
			{(#testTargets -> {TSSequentialAnimation}).
			(#testClass -> TSSequentialAnimationTest).
			(#GAIteration -> 2)} asDictionary) launch.
	run1 := self
		mutalkTarget: {TSSequentialAnimation}
		testSuite: {TSSequentialAnimationTest}.
	run2 := self
		mutalkTarget: {TSSequentialAnimation}
		testSuite: {newTest}.
	self
		assert: run2 generalResult mutationScore > run1 generalResult mutationScore
]

{ #category : #tests }
EvolutionaryAmpliferTest >> testRunSmallBank2 [
	| newTest run1 run2 |
	newTest := (Amplification
		initializeWithTests:
			{(#testTargets -> {SmallBank2}).
			(#testClass -> SmallBank2Test).
			(#GAIteration -> 2)} asDictionary) launch.
	run1 := self mutalkTarget: {SmallBank2} testSuite: {SmallBank2Test}.
	run2 := self mutalkTarget: {SmallBank2} testSuite: {newTest}.
	self
		assert: run2 generalResult mutationScore > run1 generalResult mutationScore
]
