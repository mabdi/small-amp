Extension { #name : #DrTests }

{ #category : #'*DrTests-Amplification' }
DrTests class >> buildAmplificationCommandsWith: presenter for: aCmCommandsGroup [
	<extensionCommands>
	(aCmCommandsGroup / 'List items menu')
		register: DTAmplifyTestCaseCommand forSpec
]
