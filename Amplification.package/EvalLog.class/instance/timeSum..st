math functions
timeSum: anIdx
	^ (self loggers at: anIdx) collect: [ :x | |s| s:=0.x doWithIndex: [:y :i | i odd ifTrue: [ s := s - y ] ifFalse: [ s:= s+ y ]  ]. s  ] 