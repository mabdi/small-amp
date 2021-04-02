# small-amp
[![Build Status](https://travis-ci.com/mabdi/smalltalk-test-grinder.svg?branch=main)](https://travis-ci.com/github/mabdi/smalltalk-test-grinder)

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

## How to use: Hook

You can also ask SmallAmp to generate assertions for you:

![SmallAmp](https://user-images.githubusercontent.com/3696683/86917621-a71f0480-c125-11ea-9f25-09ed7d6cf358.gif)

Add this line to your test method: `SmallAmp assertionsHere: self for: anObject` (replace `anObject` with a object from your test method).
And run the test. Test will refactor itself and add new assertions.
