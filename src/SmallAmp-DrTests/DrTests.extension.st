Extension { #name : #DrTests }

{ #category : #'*SmallAmp-DrTests' }
DrTests class >> buildAmplificationCommandsWith: presenter for: aCmCommandsGroup [
	<extensionCommands>
	aCmCommandsGroup / 'List items menu' register: SABrowseTestTargetCommand  forSpec
]
