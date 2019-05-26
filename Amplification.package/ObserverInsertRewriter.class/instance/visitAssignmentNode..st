visiting
visitAssignmentNode: anAssignmentNode
	
	anAssignmentNode parent parent class = RBMethodNode
		ifTrue: [ targetNodes add: anAssignmentNode ]