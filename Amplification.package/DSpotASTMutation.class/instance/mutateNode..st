as yet unclassified
mutateNode: aNode
	self operators
		detect: [ :op | op canHandle: aNode ]
		ifFound: [ :op | ^ op mutateNode: aNode ].
		^ {  }