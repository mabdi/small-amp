Extension { #name : #MutationTestingGeneralResult }

{ #category : #'*SmallAmp' }
MutationTestingGeneralResult >> mutationScoreFloat [
	"Returns the mutation Score of this general result. A mutation score is the
	killedOrTerminatedMutants / numberOfEvaluatedMutants"

	self numberOfEvaluatedMutants = 0
		ifTrue: [ ^ 0.0 ].
	^ (self numberOfKilledOrTerminatedMutants * 100
		/ self numberOfEvaluatedMutants) asFloat
]
