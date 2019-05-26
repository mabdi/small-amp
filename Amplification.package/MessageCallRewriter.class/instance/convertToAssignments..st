as yet unclassified
convertToAssignments: aMethod
	| idx y i |
	i := 0.
	targetNodes
		do: [ :x | 
			i := i + 1.
			idx := aMethod body statements indexOf: x.
			y := RBAssignmentNode new.
			y variable: (RBVariableNode named: (tmpVariables at: i)).
			y value: x.
			y parent: aMethod body.
			aMethod body statements at: idx put: y ]