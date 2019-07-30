accessing
withdraw: amount
<SmallAmpAction>
	balance >= amount
		ifTrue: [ balance := balance - amount ]