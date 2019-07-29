changing suspended state
installMethod: aMethod
	"Install myself instead of the CompiledMethod in the class holding it.
     This way, when sending a message to the CompiledMethod (to execute it for example)
     I am notified and I can remember that the method was run.
    "

	aMethod class = CompiledMethod
		ifFalse: [ Error new signal: 'Curropted class. use FixClass' ].
	aMethod methodClass methodDict at: aMethod selector put: self