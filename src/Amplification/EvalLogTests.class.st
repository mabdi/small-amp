Class {
	#name : #EvalLogTests,
	#superclass : #TestCase,
	#instVars : [
		'loggers'
	],
	#category : #'Amplification-Tests'
}

{ #category : #tests }
EvalLogTests >> testWorking [
	|n|
	n:=4.
	1 to: n do: [ :idx | 
		Transcript
			show: ((EvalLog instance summary at: #time_all) at: idx) asString;
			cr.
		Transcript
			show: ((EvalLog instance summary at: #input_amp) at: idx) asString;
			cr.
		Transcript
			show: ((EvalLog instance summary at: #assert_amp) at: idx) asString;
			cr.
		Transcript
			show: ((EvalLog instance summary at: #selection) at: idx) asString;
			cr.
		Transcript
			show: ((EvalLog instance summary at: #temps) at: idx) asString;
			cr;
			cr;
			cr ].
		EvalLog instance summary 
]
