accessing
withdraw: amount
	(balance >= amount) ifTrue: [ balance := balance - amount]