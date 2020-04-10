Extension { #name : #DateAndTime }

{ #category : #'*SmallAmp' }
DateAndTime >> smallAmpAcceptSerializerVisitor: aVisitor atDepth:  depth [

^ aVisitor visitDateTime: self atDepth: depth 
]
