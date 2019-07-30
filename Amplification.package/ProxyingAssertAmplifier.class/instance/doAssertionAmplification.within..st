as yet unclassified
doAssertionAmplification: aMethodSrc within: aClass
	"| generatedClass observer aMethod |
	aMethod := RBParser parseMethod: aMethodSrc.
	self insertObservers: aMethod.
	generatedClass := self buildAxularyClass: aMethod basedOn: aClass.
	generatedClass suite run.
	observer := generatedClass observer.
	self insertAsserts: aMethod using: observer.
	generatedClass removeFromSystem.
	^ aMethod formattedCode"

	| generatedClass observer |
	observer := Observer new.
	generatedClass := ASTHelper uniqueInstance
		buildAnTestClassWith: {}
		using: aClass.
	generatedClass compile: aMethodSrc.
	targets
		do: [ :aTarget | 
			(Pragma allNamed: #SmallAmpAction in: aTarget)
				do: [ :pragma | 
					ObservationProxy
						for: pragma method
						observer: observer
						inside: generatedClass ] ].
	[ generatedClass suite run ]
		ensure: [ targets
				do:
					[ :aTarget | aTarget methods do: [ :mtd | ObservationProxy fixMethod: mtd ] ] ].
	
	generatedClass removeFromSystem.
	^ self insertAsserts: aMethodSrc using: observer