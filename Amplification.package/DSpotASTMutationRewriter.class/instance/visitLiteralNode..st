visiting
visitLiteralNode: aLiteralNode
	| mutants |
	mutants := self mutationsOfLiteralNode: aLiteralNode.
	mappings add: aLiteralNode -> mutants