"
A SASmallAmpDashboardJSONExporterTest is a test class for testing the behavior of SASmallAmpDashboardJSONExporter
"
Class {
	#name : #SASmallAmpDashboardJSONExporterTest,
	#superclass : #TestCase,
	#category : #'SmallAmp-Tests-Helpers'
}

{ #category : #test }
SASmallAmpDashboardJSONExporterTest >> getJson [

	^ '{
	"numberOfProcessedMethods" : 3,
	"oracleReductionReverts" : 0,
	"targetClasses" : [
		"FakeSmallBank"
	],
	"testMethodsIgnored" : [ ],
	"methodsNotProfiled" : [ ],
	"numberOfOriginalTestMethods" : 3,
	"notCoveredInAmplified" : [ ],
	"mutationScoreBefore" : 54.54545454545455,
	"mutationScoreAfter" : 100.0,
	"testClassTimeToRunInMillis" : 3,
	"testAmpLoc" : "N/A",
	"amplifiedMethods" : [ 
		{
			"selector_generated" : "testDeposit_amp_A1",
			"selector_pretty" : "testDeposit_amp_A1",
			"from" : "FakeSmallBankTest>>#testDeposit",
			"newCoverage" : [
				"ReplaceIfTrueReceiverWithTrueOperator#FakeSmallBank#withdraw:#19#92"
			],
			"transformations" : [
				"A1"
			]
		},
		{
			"selector_generated" : "testDeposit_amp",
			"selector_pretty" : "testDeposit_amp",
			"from" : "FakeSmallBankTest>>#testDeposit",
			"newCoverage" : [
				"RemoveCaretOperator#FakeSmallBank#rand#28#50"
			],
			"transformations" : [ ]
		},
		{
			"selector_generated" : "testWithdraw_amp_U0",
			"selector_pretty" : "testWithdraw_amp_U0",
			"from" : "FakeSmallBankTest>>#testWithdraw",
			"newCoverage" : [
				"ReplaceGreaterOrEqualWithGreaterMutantOperator#FakeSmallBank#withdraw:#19#35"
			],
			"transformations" : [
				"U0"
			]
		}
	],
	"testLoc" : "17",
	"numberOfAllMutationsInOriginal" : 11,
	"targetLoc" : 15,
	"amplifiedClass" : "FakeSmallBankTestAmpResult",
	"newCovered" : [
		{
			"operatorDescription" : "Remove ^",
			"class" : "FakeSmallBank",
			"operatorClass" : "RemoveCaretOperator",
			"mutationStart" : 28,
			"method" : "rand",
			"mutatedNode" : "(1 to: 1000) atRandom",
			"mutationEnd" : 50
		},
		{
			"operatorDescription" : "Remove ^",
			"class" : "FakeSmallBank",
			"operatorClass" : "RemoveCaretOperator",
			"mutationStart" : 85,
			"method" : "withdraw:",
			"mutatedNode" : "true",
			"mutationEnd" : 90
		},
		{
			"operatorDescription" : "Remove ^",
			"class" : "FakeSmallBank",
			"operatorClass" : "RemoveCaretOperator",
			"mutationStart" : 96,
			"method" : "withdraw:",
			"mutatedNode" : "false",
			"mutationEnd" : 102
		},
		{
			"operatorDescription" : "Replace #''>='' with #>",
			"class" : "FakeSmallBank",
			"operatorClass" : "ReplaceGreaterOrEqualWithGreaterMutantOperator",
			"mutationStart" : 19,
			"method" : "withdraw:",
			"mutatedNode" : "balance > amount",
			"mutationEnd" : 35
		},
		{
			"operatorDescription" : "Replace #ifTrue: receiver with true",
			"class" : "FakeSmallBank",
			"operatorClass" : "ReplaceIfTrueReceiverWithTrueOperator",
			"mutationStart" : 19,
			"method" : "withdraw:",
			"mutatedNode" : "true ifTrue: [ \r\tbalance := balance - amount.\r\t^ true ]",
			"mutationEnd" : 92
		}
	],
	"timeBudgetFinished" : false,
	"notCoveredInOriginal" : [
		{
			"operatorDescription" : "Remove ^",
			"class" : "FakeSmallBank",
			"operatorClass" : "RemoveCaretOperator",
			"mutationStart" : 28,
			"method" : "rand",
			"mutatedNode" : "(1 to: 1000) atRandom",
			"mutationEnd" : 50
		},
		{
			"operatorDescription" : "Remove ^",
			"class" : "FakeSmallBank",
			"operatorClass" : "RemoveCaretOperator",
			"mutationStart" : 85,
			"method" : "withdraw:",
			"mutatedNode" : "true",
			"mutationEnd" : 90
		},
		{
			"operatorDescription" : "Remove ^",
			"class" : "FakeSmallBank",
			"operatorClass" : "RemoveCaretOperator",
			"mutationStart" : 96,
			"method" : "withdraw:",
			"mutatedNode" : "false",
			"mutationEnd" : 102
		},
		{
			"operatorDescription" : "Replace #''>='' with #>",
			"class" : "FakeSmallBank",
			"operatorClass" : "ReplaceGreaterOrEqualWithGreaterMutantOperator",
			"mutationStart" : 19,
			"method" : "withdraw:",
			"mutatedNode" : "balance > amount",
			"mutationEnd" : 35
		},
		{
			"operatorDescription" : "Replace #ifTrue: receiver with true",
			"class" : "FakeSmallBank",
			"operatorClass" : "ReplaceIfTrueReceiverWithTrueOperator",
			"mutationStart" : 19,
			"method" : "withdraw:",
			"mutatedNode" : "true ifTrue: [ \r\tbalance := balance - amount.\r\t^ true ]",
			"mutationEnd" : 92
		}
	],
	"originalTestCase" : "FakeSmallBankTest",
	"testCase" : "FakeSmallBankTest",
	"unixtime" : 1645799842,
	"timeTotal" : 8,
	"numberOfTestMethodsBeforeShreding" : 3
}'
]

{ #category : #test }
SASmallAmpDashboardJSONExporterTest >> testExportClassSmallampJson [

	| ins cls json dict |
	cls := FakeSmallBankTestAmpResult.
	json := STONJSON fromString: self getJson.
	ins := SASmallAmpDashboardJSONExporter new.
	ins root: 'src'.
	dict := ins exportClass: cls smallampJson: json.
	
	self assert: (dict at: #amplified_tests) size equals: 3
]
