# small-amp
[![Build Status](https://travis-ci.org/mabdi/small-amp.svg?branch=master)](https://travis-ci.org/mabdi/small-amp)

SmallAmp is an open source test amplification tool in Pharo Smalltalk. SmallAmp transforms existing test methods to generate a set of new test methods that increase mutation coverage on selected class.

### Current status 

- under development

## How to load
```smalltalk
Metacello new
  baseline: 'SmallAmp';
  repository: 'github://mabdi/small-amp/src';
  load.
```

## How to use: DrTests

SmallAmp can be used as a plugin for DrTest. More informaion [here](https://github.com/mabdi/small-amp/wiki/DrTests-Plugin).

## How to use: Code



```smalltalk
	| result |
	result := SmallAmp initializeDefault
		testCase: SmallBankTest targets: {SmallBank};
		testCase: SmallBank2Test targets: {SmallBank2};
		amplifyAll.
	result inspect.
 ```
 
 You can find the generated testcases in `SmallAmpTempClasses` package. 
