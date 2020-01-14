# small-amp
[![Build Status](https://travis-ci.org/mabdi/small-amp.svg?branch=master)](https://travis-ci.org/mabdi/small-amp)

Test Amplification for Pharo

### Current status 

- under development

## How to load
```smalltalk
Metacello new
  baseline: 'SmallAmp';
  repository: 'github://mabdi/small-amp/src';
  load.
```

## How to use

```smalltalk
example
	| config result |
	config := SAConfig new
		iterations: 3;
		assertionAmplifiers: {SADefaultAssertionAmplifier};
		inputAmplifiers: {SALiteralInputAmplifier};
		selections: {SAMutationCoverageSelection};
		minifiers:
			{SANoMinification.
			SAMuTalkFirstFailMinifier.
			SAMuTalkNeverFailMinifier};
		"debug: true;"
			yourself.
	result := (SmallAmp initializeWith: config)
		testCase: SmallBankTest targets: {SmallBank};
		testCase: SmallBank2Test targets: {SmallBank2};
		amplifyAll.
 ```
 
 You can find the generated testcases in `SmallAmpTempClasses` package. 
