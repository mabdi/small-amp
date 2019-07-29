changing suspended state
doesNotUnderstand: aMessage
	"Messages not understood by myself are forwarded to the CompiledMethod I hold."

	^ method perform: aMessage selector withArguments: aMessage arguments