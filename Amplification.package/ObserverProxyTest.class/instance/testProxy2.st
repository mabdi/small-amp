tests
testProxy2
	| b observer mtds |
	observer := Observer new.
	mtds := { SmallBank >> #withdraw: .  SmallBank >> #deposit:}.
	mtds do: [ :mtd | ObservationProxy for: mtd observer: observer inside: self].	
	b := SmallBank new.
	b deposit: 10.
	b deposit: 20.
	b withdraw: 4.
		mtds do: [ :mtd | ObservationProxy fixMethod: mtd ] 