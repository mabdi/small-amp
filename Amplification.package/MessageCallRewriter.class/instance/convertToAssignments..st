as yet unclassified
convertToAssignments: aMethod
	| idx y i tmps |
	i := 0.
	tmps := aMethod temporaryNames
		select: [ :tmp | tmp beginsWith: 'tmp_' ].
	targetNodes
		do: [ :x | 
			i := i + 1.
			idx := aMethod body statements indexOf: x.
			y := RBAssignmentNode new.
			y variable: (RBVariableNode named: (tmps at: i)).
			y value: x.
			y parent: aMethod body.
			aMethod body statements at: idx put: y ]