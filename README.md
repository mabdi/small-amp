# SmallAmp
[![Build Status](https://travis-ci.org/mabdi/small-amp.svg?branch=master)](https://travis-ci.org/mabdi/small-amp)
[![smalltalkCI](https://github.com/mabdi/small-amp/actions/workflows/smalltalkCI.yml/badge.svg)](https://github.com/mabdi/small-amp/actions/workflows/smalltalkCI.yml)

## Scope

SmallAmp is an open-source test amplification tool in Pharo Smalltalk.
It transforms existing test methods to generate a set of new test methods, then it filters all tests that increase the coverage.
The selected tests then are provided for the developer to be revised and merge in the code base.
SmallAmp uses mutation testing as the default coverage metric.
For more information check [Advanced topics](## Advanced topics).

> **In a nutshell:** Developers can use SmallAmp on their projects to generate new test methods which increase the coverage. However, it is important to be an existing test suite with an acceptable test coverage.

You can use it in two ways:
- Using SmallAmpCI to integrate it in GitHub-Actions. ([how to](## Using SmallAmpCI))
- Run it locally on a Pharo image. ([how to](## Loading SmallAmp into a local image))

## Using SmallAmpCI

### How to setup GitHub-actions workflow?

### (Optional) Annotatins on the project to help SmallAmp

### How to review the outputs

#### Using GitHub web interface


#### Using a Pharo image

### How to uninstall SmallAmp


## Loading SmallAmp into a local image

### How to load
```smalltalk
Metacello new
  baseline: 'SmallAmp';
  repository: 'github://mabdi/small-amp/src';
  load.
```

### How to use: DrTests

SmallAmp can be used as a plugin for DrTest. More informaion [here](https://github.com/mabdi/small-amp/wiki/DrTests-Plugin).

### How to use: Code

```smalltalk
	| result |
	result := SmallAmp initializeDefault
		testCase: SmallBankTest targets: {SmallBank};
		testCase: SmallBank2Test targets: {SmallBank2};
		amplifyAll.
	result inspect.
 ```
 
 You can find the generated testcases in `SmallAmpTempClasses` package. 

### How to use: Hook

You can also ask SmallAmp to generate assertions for you:

![SmallAmp](https://user-images.githubusercontent.com/3696683/86917621-a71f0480-c125-11ea-9f25-09ed7d6cf358.gif)

Add this line to your test method: `SmallAmp assertionsHere: self for: anObject` (replace `anObject` with a object from your test method).
And run the test. Test will refactor itself and add new assertions.


## Advanced topics

### How SmallAmp works?


### What is mutation testing?


