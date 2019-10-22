"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestAmplification,
	#superclass : #PackageManifest,
	#category : #'Amplification-Manifest'
}

{ #category : #'code-critics' }
ManifestAmplification class >> ruleRBEqualsTrueRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#SmallBankTest14984 #testWithdraw_13_1 #false)) #'2019-07-04T19:51:44.613818+02:00') )
]

{ #category : #'code-critics' }
ManifestAmplification class >> ruleRBLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#SmallBankTest14984 #testWithdraw_13_1 #false)) #'2019-07-04T19:51:51.061401+02:00') )
]
