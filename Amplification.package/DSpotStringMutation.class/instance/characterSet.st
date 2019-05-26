recursive descent
characterSet
	^ String
		streamContents: [ :stream | 
			stream write: Character alphabet.
			stream write: Character alphabet asUppercase.
			stream write: '0123456789'.
			stream write: '!@#$%^&*(){}\|''";:?/.>,<`~§±'.
			stream write: Character space.
			stream write: Character cr . stream
				write: Character tab ]