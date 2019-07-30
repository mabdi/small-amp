changing suspended state
run: aSelector with: anArray in: aReceiver
	| result elapsedTime exception |
	[ [ elapsedTime := Time
		millisecondsToRun: [ result := aReceiver withArgs: anArray executeMethod: method ].
	^ result ]
		on: Error
		do: [ :ex | exception := ex ] ]
		ensure: [ self observe: aReceiver selector: aSelector args: anArray results: result exception: exception time: elapsedTime  ]