Class {
	#name : #SAAssertionDialog,
	#superclass : #SpPresenter,
	#instVars : [
		'table',
		'asserts',
		'observation',
		'onMerge',
		'mergeButton'
	],
	#category : #'SmallAmp-Spec-UI'
}

{ #category : #specs }
SAAssertionDialog class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #table;
		add: #asserts;
		add: #mergeButton expand: false
			fill: false
			padding: 0;
		yourself
]

{ #category : #example }
SAAssertionDialog class >> example [
	| object observation |
	object := Array
		with:
			(SmallBank new
				deposit: 100;
				yourself)
		with: 10
		with: (1 to: 4) asOrderedCollection
		with: ((1 to: 4) collect: [ :i | i @ i + 1 ]).
	observation := object
		smallAmpAcceptSerializerVisitor: (SAStateSerializer withDepth: 4)
		atDepth: 1.
	observation name: 'object'.
	^ self openOn: observation
]

{ #category : #'instance creation' }
SAAssertionDialog class >> open [
	<script>
	^ self new
		openWithSpec;
		yourself
]

{ #category : #'instance creation' }
SAAssertionDialog class >> openOn: anObservation [
	<script>
	^ self new
		observation: anObservation;
		openWithSpec;
		yourself
]

{ #category : #'instance creation' }
SAAssertionDialog class >> openOn: anObservation onMerge: aBlock [ 
	<script>
	^ self new
		observation: anObservation;
		onMerge: aBlock;
		openWithSpec;
		yourself
]

{ #category : #accessing }
SAAssertionDialog >> defaultMergeAction [
	^ [ :text | Clipboard clipboardText: text ]
]

{ #category : #initialization }
SAAssertionDialog >> initializePresenters [
	table := self newTreeTable.
	table
		addColumn:
			(SpCompositeTableColumn new
				addColumn:
					((SpCheckBoxTableColumn title: ' ' evaluated: [ :item | item active ])
						onActivation: [ :item | 
							item active: true.
							self refreshTable.
							self refreshCode ];
						onDesactivation: [ :item | 
							item active: false.
							self refreshTable.
							self refreshCode ];
						width: 20;
						yourself);
				addColumn: (SpStringTableColumn evaluated: #specTreeName);
				yourself);
		children: #specTreeChildren;
		whenActivatedDo: [ :item |  ];
		contextMenu: self menu;
		whenSelectionChangedDo: [ :selections | "selections selectedItem
				ifNotNil: [ self
						itemSelected: selections selectedItem
						path: selections selectedPath ]" ].
	asserts := self newCode.
	asserts
		whenBuiltDo: [ :ann | ann widget font: StandardFonts codeFont ].
	mergeButton := self newButton.
	mergeButton label: 'Merge'.
	mergeButton
		action: [ self onMerge value: asserts text.
			self window close ]
]

{ #category : #initialization }
SAAssertionDialog >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: 'SmallAmp';
		initialExtent: 600 @ 700
]

{ #category : #initialization }
SAAssertionDialog >> itemSelected: anObservation path: aPath [
	| assertsCode |
	self flag: #todo.	"cache based on path"
	assertsCode := RBSequenceNode
		statements: (anObservation buildAssertions: SAAssertGenerator new).
	assertsCode := assertsCode formattedCode.
	asserts text: assertsCode
]

{ #category : #api }
SAAssertionDialog >> menu [
	^ self newMenu
		addItem: [ :anItem | 
			anItem
				name: 'Select All Childs';
				visibleIf: [ table selectedItem specTreeChildren isNotEmpty ];
				action: [ table selectedItem specTreeChildren do: [ :ch | ch active: true ].
					self refreshTable ] ];
		addItem: [ :anItem | 
			anItem
				name: 'Deselect All Childs';
				visibleIf: [ table selectedItem specTreeChildren isNotEmpty ];
				action: [ table selectedItem specTreeChildren do: [ :ch | ch active: false ].
					self refreshTable ] ]
]

{ #category : #accessing }
SAAssertionDialog >> observation [
	^ observation
]

{ #category : #accessing }
SAAssertionDialog >> observation: anObject [
	observation := anObject.
	table roots: {observation}.
	self refreshCode
]

{ #category : #accessing }
SAAssertionDialog >> onMerge [
	onMerge
		ifNil: [ onMerge := self defaultMergeAction ].
	^ onMerge
]

{ #category : #accessing }
SAAssertionDialog >> onMerge: anObject [
	onMerge := anObject
]

{ #category : #initialization }
SAAssertionDialog >> refreshCode [
	| assertsCode |
	assertsCode := RBSequenceNode
		statements: (observation buildAssertions: SAAssertGenerator new).
	assertsCode := assertsCode formattedCode.
	asserts text: assertsCode
]

{ #category : #updating }
SAAssertionDialog >> refreshTable [
	table needRebuild: true.
	table buildWithSpec
]
