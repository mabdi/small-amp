as yet unclassified
insertObservers: aMethod
	| aVisitor |
	aVisitor := MessageCallRewriter new.
	aVisitor doYourJob: aMethod.
	aVisitor := ObserverInsertRewriter new.
	aVisitor doYourJob: aMethod.
	