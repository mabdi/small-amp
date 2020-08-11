Extension { #name : #Point }

{ #category : #'*SmallAmp' }
Point class >> smallAmpBuildAssertions: observation by: aGenerator [
	^ aGenerator buildAssertionsPoint: observation 
]
