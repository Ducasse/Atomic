"
Base class for the representation of the map structure. Maps basically have the configuration, a record number of moves and name.
"
Class {
	#name : #AtomicMap,
	#superclass : #Object,
	#instVars : [
		'mapStyle',
		'layout'
	],
	#category : #Atomic
}

{ #category : #enumerating }
AtomicMap class >> E [
	^ 1 @ 0.
]

{ #category : #enumerating }
AtomicMap class >> N [
	^ 0 @ -1.

]

{ #category : #enumerating }
AtomicMap class >> NE [
	^  1 @ -1.

]

{ #category : #enumerating }
AtomicMap class >> NW [
	^  -1 @ -1
]

{ #category : #enumerating }
AtomicMap class >> S [
	^ 0 @ 1.
	
]

{ #category : #enumerating }
AtomicMap class >> SE [
	^  1 @ 1.

]

{ #category : #enumerating }
AtomicMap class >> SW [
	^  -1 @ 1.

]

{ #category : #enumerating }
AtomicMap class >> W [
	^ -1 @ 0.

]

{ #category : #'access properties' }
AtomicMap class >> pointPreviewInAtoms: aDescriptor [
	| previewX previewY |	
	aDescriptor isArray ifTrue: [
		"symbol   := descriptor at: 1."
		previewX := aDescriptor at: 2.
		previewY := aDescriptor at: 3.
		^ previewX @ previewY.
	].
	^ nil.

]

{ #category : #'access properties' }
AtomicMap >> atomPosition: indexes [ 
	^ self atomSize  * indexes + self borderSpace
]

{ #category : #'access properties' }
AtomicMap >> atomSize [
	^ mapStyle isSmallScreen
		ifTrue: [ 14 @ 14 ]
		ifFalse: [ 28 @ 28 ]
]

{ #category : #'access properties' }
AtomicMap >> borderSpace [
	^ 10 @ 5
]

{ #category : #'access properties' }
AtomicMap >> buildLayout: aOwnerPanel [ 
	| style beginning item object newPos newBound |
	style := AtomicMapStyle new.
	beginning := aOwnerPanel bounds bottomLeft.
	1
		to: layout columnCount
		do: [ :r | 1
				to: layout rowCount
				do: [ :c | 
					item := layout at: c at: r.
					object := self createComponents: item.
					object
						ifNotNil: [object mapStyle: style.
							newPos := self atomPosition: c @ r - 1.
							newBound := newPos corner: newPos + self atomSize.
							newBound := newBound translateBy: beginning.
							object bounds: newBound.
							aOwnerPanel addMorphBack: object]]]
]

{ #category : #'access properties' }
AtomicMap >> buildLayout: aOwnerPanel startOn: beginning mapStyle: aMapStyle [
	| item component newPoint translatedPoint newBound |	
	1 to: layout columnCount do: [ 
		:r | 
		1 to: layout rowCount do: [ 
			:c | 
			item := layout at: c at: r.
			component := self createComponents: item mapStyle: aMapStyle.
			component ifNotNil: [
				"Map contains the starting point of the atom and preview atom"
				newPoint := aMapStyle isPreview 
									ifTrue: [ (self class pointPreviewInAtoms: item) - 1 ] 
									ifFalse: [ (c @ r) - 1 ].
				translatedPoint := aMapStyle atomPosition: newPoint.
				newBound := translatedPoint corner: translatedPoint + aMapStyle atomSize.
				component bounds: newBound.
				newBound := newBound translateBy: beginning.
				aOwnerPanel includeMorph: component position: newBound origin.
			]
		]
	].
]

{ #category : #'access properties' }
AtomicMap >> buildLayoutForPreview: aOwnerPanel [ 
	"From the map extract all the atom and build the assembled molecule (used to show the assembled molecule) based on the map specification. "
	| style beginning item object newPos newBound |
	style := AtomicMapStyle newForPreview.
	beginning := aOwnerPanel bounds topRight.
	1
		to: layout columnCount
		do: [ :r | 1
				to: layout rowCount
				do: [ :c | 
					item := layout at: c at: r.
					object := self createComponentsForPreview: item.
					object
						ifNotNil: ["Specially for preview"
							object mapStyle: style.
							previewExtent := previewExtent max: object previewPosition.
							newPos := self atomPosition: object previewPosition - 1.
							newBound := newPos corner: newPos + self atomSize.
							newBound := newBound translateBy: beginning.
							object bounds: newBound.
							aOwnerPanel addMorph: object]]]
]

{ #category : #'element creation' }
AtomicMap >> createAtoms: aDescriptor [ 
	"Returns the atom with the predefined setting"
	| atomKind requiredClass items previewX previewY |
	atomKind := aDescriptor at: 1.
	"get the class"
	requiredClass := self getClassOf: atomKind.
	requiredClass
		ifNotNil: ["preview position"
			previewX := aDescriptor at: 2.
			previewY := aDescriptor at: 3.
			"removes used settings"
			items := ((aDescriptor copyWithout: atomKind)
						copyWithout: previewX)
						copyWithout: previewY.
			"builds the atom"
			^ ((requiredClass new
				links: (self extractLinks: items))
				forcedLinks: (self extractForcedLinks: items))
				previewPosition: previewX @ previewY].
	"Shows an error"
	self log: 'Unknown Atom kind: ' , atomKind asString.
	^ nil
]

{ #category : #'element creation' }
AtomicMap >> createAtoms: aDescriptor mapStyle: aMapStyle [
	"Returns the atom with the predefined setting"
	| atomKind requiredClass descriptor newLinks newForcedLinks |
	atomKind := aDescriptor at: 1.
	"get the class"
	requiredClass := AtomicAtom getClassOf: atomKind.
	requiredClass ifNotNil: [
			"removes used settings"
			descriptor := aDescriptor copyWithout: atomKind.
			newLinks := AtomicAtom extractLinks: descriptor.
			newForcedLinks := AtomicAtom extractForcedLinks: descriptor.
			"builds the atom"
			^ requiredClass new withMapStyle: aMapStyle links: newLinks forcedLinks: newForcedLinks.
		].
	"Shows an error"
	self error: 'Unknown Atom kind: ' , atomKind asString.
	^ nil
]

{ #category : #'element creation' }
AtomicMap >> createComponents: aDescriptor [
	"Spaces"
	aDescriptor = 0
		ifTrue: [^ nil].
	"Bricks"
	aDescriptor = 1
		ifTrue: [^ AtomicBrick new].
	"Atom"
	(aDescriptor isKindOf: Array)
		ifTrue: [^ self createAtoms: aDescriptor].
	"Nothing"
	^ nil
]

{ #category : #'element creation' }
AtomicMap >> createComponents: aDescriptor mapStyle: aMapStyle [
	"Atom"
	(aDescriptor isArray) ifTrue: [^ self createAtoms: aDescriptor mapStyle: aMapStyle].
	
	"Spaces"
	aDescriptor = 0 ifTrue: [ ^ nil ].

	"Preview does not need bricks and stuff.."
	aMapStyle isPreview ifTrue: [ ^ nil ].

	"Bricks"
	aDescriptor = 1 ifTrue: [ ^ AtomicBrick new withMapStyle: aMapStyle ].
		
	"Nothing"
	^ nil
]

{ #category : #'element creation' }
AtomicMap >> createComponentsForPreview: aDescriptor [ 
	"Atom"
	(aDescriptor isKindOf: Array)
		ifTrue: [^ self createAtoms: aDescriptor].
	"Nothing"
	^ nil
]

{ #category : #'element creation' }
AtomicMap >> createLayout [
	"Returns the matrix describing the field as well as the atoms"

	self subclassResponsibility

	"The format is like follows..
	
	layout := Matrix rows: 9 columns: 11.
	layout atRow: 1 put: #(1 1 1 1 1 1 1 1 1 1 1).
	layout atRow: 2 put: #(1 0 0 1 0 0 0 0 0 0 1).
	layout atRow: 3 put: #(1 0 #(#H 3 1 #w) 1 0 0 0 0 0 0 1)
	
	0 are SPACE.. to make it easier to read
	1 are BRICKS.. to make it easier to read
	#(H 3 1 #w).. is the Hydrogen Atom
	..
	"
]

{ #category : #'access properties' }
AtomicMap >> extractForcedLinks: aSymbolList [ 
	| result requiredClass |
	result := Bag new.
	aSymbolList
		do: [ :item | 
			requiredClass := self getClassOf: item.
			requiredClass
				ifNotNil: [ result add: requiredClass ] ].
	^ result
]

{ #category : #'access properties' }
AtomicMap >> extractLinks: aSymbolList [ 
	| result link |
	result := Bag new.
	aSymbolList
		do: [:item | 
			link := nil.
			"Create a link depending the kind"
			item = #n
				ifTrue: [link := AtomicMap N].
			item = #ne
				ifTrue: [link := AtomicMap NE].
			item = #e
				ifTrue: [link := AtomicMap E].
			item = #se
				ifTrue: [link := AtomicMap SE].
			item = #s
				ifTrue: [link := AtomicMap S].
			item = #sw
				ifTrue: [link := AtomicMap SW].
			item = #w
				ifTrue: [link := AtomicMap W].
			item = #nw
				ifTrue: [link := AtomicMap NW].
			link
				ifNotNil: [result add: link]].
	^ result
]

{ #category : #'access properties' }
AtomicMap >> getClassOf: aItem [
	"Which class is related to it"
	aItem = #H
		ifTrue: [^ AtomicHydrogen ].
	aItem = #C
		ifTrue: [^ AtomicCarbon ].
	aItem = #O
		ifTrue: [^ AtomicOxygen ].
	aItem = #F
		ifTrue: [^ AtomicFluor ].
	aItem = #N
		ifTrue: [^ AtomicNitrogen ].
	aItem = #-
		ifTrue: [^ AtomicLink ].
^ nil.
]

{ #category : #initialization }
AtomicMap >> initialize [
	layout := self createLayout.
	mapStyle := AtomicMapStyle new.
]

{ #category : #'access properties' }
AtomicMap >> levelName [
	"Return the name of this level"
	self subclassResponsibility
]

{ #category : #'access properties' }
AtomicMap >> mapStyle [
	^ mapStyle
]

{ #category : #'access properties' }
AtomicMap >> neededSize [
	^ self atomSize * (layout rowCount @ layout columnCount) 
		+ (self borderSpace * 2)
]

{ #category : #'access properties' }
AtomicMap >> previewNeededSize [
	^ self atomSize * previewExtent  + (self borderSpace * 2)
]

{ #category : #'access properties' }
AtomicMap >> record [
	"Return the minimum number of moves to complete the puzzle."
	^	self subclassResponsibility
]

{ #category : #'access properties' }
AtomicMap >> sizeMapInPixels [
	^ mapStyle atomSize * (layout rowCount @ layout columnCount) + (mapStyle borderSpace * 2)
]

{ #category : #'access properties' }
AtomicMap >> sizePreviewInAtoms [
	| result descriptor previewXY |	
	result := 0 @ 0.
	1 to: layout columnCount do: [ 
		:r | 
		1 to: layout rowCount do: [ 
			:c | 
			descriptor := layout at: c at: r.
			previewXY := self class pointPreviewInAtoms: descriptor.
			previewXY isNotNil ifTrue: [ result := result max: previewXY. ].
		].
	].
	^ result.

]

{ #category : #'access properties' }
AtomicMap >> sizePreviewInPixels [
	^ (self sizePreviewInAtoms) * (mapStyle atomSize) + (mapStyle borderSpace * 2)
]
