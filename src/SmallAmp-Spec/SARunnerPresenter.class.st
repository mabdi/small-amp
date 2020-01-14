Class {
	#name : #SARunnerPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'testCasesList',
		'testTargetTextInput',
		'amplificationTree',
		'amplifyButton',
		'amplificationDiff',
		'amplificationConfiguration'
	],
	#category : #'SmallAmp-Spec-UI'
}

{ #category : #specs }
SARunnerPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add:
			(SpBoxLayout newHorizontal
				add: (SpBoxLayout newVertical
								add: 'Test Cases:' expand: false;
								add: #testCasesList;
								yourself);
				add:
					(SpBoxLayout newVertical
						add: 'Target class:' expand: false;
						add: #testTargetTextInput;
						add: #amplifyButton;
						yourself);
				add:
					(SpBoxLayout newVertical
						add: 'Amplifications:' expand: false;
						add: #amplificationTree;
						yourself);
				yourself);
			add: (SpBoxLayout newVertical
						add: 'Amplification diff:' expand: false;
						add: #amplificationDiff;
						yourself);
		yourself
]

{ #category : #example }
SARunnerPresenter class >> example [
	^ SARunnerPresenter openOn: { Array2DTest. ArrayTest. BagTest. DictionaryTest }
]

{ #category : #'instance creation' }
SARunnerPresenter class >> open [
	<script>
	^ self new
		openWithSpec;
		yourself
]

{ #category : #'instance creation' }
SARunnerPresenter class >> openOn: testCases [
	^ self new
		testCases: testCases;
		openWithSpec;
		yourself
]

{ #category : #accessing }
SARunnerPresenter >> amplificationConfiguration [
	^ amplificationConfiguration
]

{ #category : #initialization }
SARunnerPresenter >> connectPresenters [
	testCasesList whenSelectionChangedDo: [ :selection | 
		testTargetTextInput text:
			selection selectedItem suggestTargetClassName.
		testTargetTextInput enabled: true ].
	testTargetTextInput acceptBlock: [ :text | 
		testCasesList selection selectedItem targetClass:
			(self class environment at: text asSymbol).
		self flag: #TODO. "Here we need to update the list so the icon match with model state." ].
	
	amplifyButton action: [ self startAmplifyProcess ]
]

{ #category : #running }
SARunnerPresenter >> diff: aMethod with: anotherMethod [
	amplificationDiff
		leftText: aMethod sourceCode;
		rightText: anotherMethod sourceCode
]

{ #category : #initialization }
SARunnerPresenter >> initializePresenters [
	testCasesList := self newList.
	testCasesList
		beSingleSelection;
		display: [ :testConfiguration | 
			testConfiguration displayString ];
		icons: [ :testConfiguration |
			self iconNamed: testConfiguration icon ].
	testTargetTextInput := self newTextInput.
	testTargetTextInput enabled: false.
	amplificationTree := self newTreeTable.
	amplifyButton := self newButton.
	amplifyButton label: 'Amplify!'.
	amplificationDiff := self newDiff
]

{ #category : #initialization }
SARunnerPresenter >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'SmallAmp';
		initialExtent: 600 @ 400
]

{ #category : #running }
SARunnerPresenter >> startAmplifyProcess [
	self flag: #TODO.
	self diff: SARunnerPresenter >> #startAmplifyProcess with: SARunnerPresenter >> #diff:with:
]

{ #category : #tests }
SARunnerPresenter >> testCases: aCollectionOfTestCases [
	amplificationConfiguration := SAAmplificationConfiguration new.
	aCollectionOfTestCases do: [ :testCase | 
		amplificationConfiguration addConfiguration: (SATestCaseConfiguration testCase: testCase) ].
	
	testCasesList items: amplificationConfiguration testCaseConfigurations
]

{ #category : #accessing }
SARunnerPresenter >> testCasesList [
	^ testCasesList
]

{ #category : #accessing }
SARunnerPresenter >> testTargetTextInput [
	^ testTargetTextInput
]
