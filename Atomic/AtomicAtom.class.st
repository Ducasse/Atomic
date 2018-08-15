"
Base class for the atoms you see on the map. Mainly related with drawing.

"
Class {
	#name : #AtomicAtom,
	#superclass : #AtomicComponent,
	#instVars : [
		'links',
		'forcedLinks',
		'previewPosition'
	],
	#category : #Atomic
}

{ #category : #'access properties' }
AtomicAtom class >> extractForcedLinks: aSymbolList [ 
	| newLinks requiredClass |
	newLinks := Bag new.
	aSymbolList do: [ 
		:item | 
		requiredClass := AtomicAtom getClassOf: item.
		requiredClass ifNotNil: [ newLinks add: requiredClass. ]
	].
	^ newLinks
]

{ #category : #'access properties' }
AtomicAtom class >> extractLinks: aSymbolList [ 
	| newLinks |
	newLinks := Bag new.
	aSymbolList do: [
		:item | 
		item = #n  ifTrue: [ newLinks add: AtomicMap N ].
		item = #ne ifTrue: [ newLinks add: AtomicMap NE ].
		item = #e  ifTrue: [ newLinks add: AtomicMap E ].
		item = #se ifTrue: [ newLinks add: AtomicMap SE ].
		item = #s  ifTrue: [ newLinks add: AtomicMap S ].
		item = #sw ifTrue: [ newLinks add: AtomicMap SW ].
		item = #w  ifTrue: [ newLinks add: AtomicMap W ].
		item = #nw ifTrue: [ newLinks add: AtomicMap NW ].
	].
	^ newLinks.
]

{ #category : #'access properties' }
AtomicAtom class >> getClassOf: aItem [
	"Which class is related to it"
	aItem = #H ifTrue: [^ AtomicHydrogen ].
	aItem = #C ifTrue: [^ AtomicCarbon ].
	aItem = #O ifTrue: [^ AtomicOxygen ].
	aItem = #F ifTrue: [^ AtomicFluor ].
	aItem = #N ifTrue: [^ AtomicNitrogen ].
	aItem = #- ifTrue: [^ AtomicLink ].
	^ nil.
]

{ #category : #'access properties' }
AtomicAtom >> atomSymbol [
	self subclassResponsibility
]

{ #category : #drawing }
AtomicAtom >> drawAtom: aCanvas [
	| newBound |
	"this adapt on the fly.."
	newBound := self bounds.
	"Preview has not shadow"
	self isPreview | self isSmallScreen
		ifTrue: [ newBound := newBound insetBy: 2 ]
		ifFalse: [ 
			"Normal screen.. leave some space"
			newBound := newBound insetBy: 5.
			"shadow"
			aCanvas fillOval: (newBound translateBy: 2) color: Color veryLightGray.
		].
	"links.."
	self drawLinks: aCanvas.
	"main shape"
	aCanvas fillOval: newBound color: self defaultColor.
	"draw the light effect.."
	self drawLight: aCanvas bound: newBound.
	"Write H2O or.. so.."
	self isSmallScreen ifFalse: [ self drawSymbolOn: aCanvas. ]

]

{ #category : #drawing }
AtomicAtom >> drawAtom: aCanvas bound: aBound [ 
	"Draw the shadow and the body"
	| newBound |
	self isSmallScreen
		ifTrue: [newBound := aBound insetBy: 2]
		ifFalse: [newBound := aBound insetBy: 4.
			"shadow"
			aCanvas
				fillOval: (newBound translateBy: 2)
				color: Color veryVeryLightGray].
	self drawLinks: aCanvas.
	aCanvas fillOval: newBound color: self defaultColor.
	^ newBound
]

{ #category : #drawing }
AtomicAtom >> drawBright: aCanvas bound: aBound [ 
	"Circles representing light"
	| selectedColor newBound |
	selectedColor := self defaultColor.
	newBound := aBound insetBy: 2.
	1
		to: 4
		do: [ :index | 
			selectedColor := selectedColor alphaMixed: 0.77 with: Color white.
			aCanvas fillOval: newBound color: selectedColor.
			newBound := (newBound insetBy: 2) translateBy: -1 ].
	^ aBound
]

{ #category : #drawing }
AtomicAtom >> drawLight: aCanvas bound: aBound [
	| selectedColor newBound |
	"this adapt on the fly.."
	selectedColor := self defaultColor.
	"the light is smaller.."
	newBound := aBound insetBy: 1.5.
	"Draw the light effect"
	1 to: 7 do: [ :index | 
		selectedColor := selectedColor alphaMixed: 0.75 with: Color white.
		aCanvas fillOval: newBound color: selectedColor.
		newBound := (newBound insetBy: 2) translateBy: -1
	].

]

{ #category : #drawing }
AtomicAtom >> drawLinks: aCanvas [ 
	"Draw the list of arrows"
	| lineWidth maxSize startPos linksCount endPos |
	maxSize := self bounds extent // 2.
	startPos := self bounds center.
	links	do: [ 
		:link | 
		"for every link"
		linksCount := (links select: [:item | item = link]) size.
		lineWidth := linksCount * 2.
		endPos := (maxSize - lineWidth + linksCount) * link + startPos.
		"draw the line"
		aCanvas line: startPos to: endPos width: lineWidth color: Color darkGray.
	]
]

{ #category : #drawing }
AtomicAtom >> drawOn: aCanvas [ 
	self drawActivation: aCanvas.
	self drawAtom: aCanvas.
]

{ #category : #drawing }
AtomicAtom >> drawSymbolOn: aCanvas [ 
	"Draw the text inside"
	| point text |
	point := self bounds center - (4@8).
	text := self atomSymbol.
	aCanvas drawString: text from: 1 to: 1 at: point font: nil color: Color black.
	aCanvas drawString: text from: 1 to: 1 at: (point - 1) font: nil color: (Color white).
	
]

{ #category : #'access properties' }
AtomicAtom >> forcedLinks: aLinks [ 
	forcedLinks := aLinks.
	
]

{ #category : #initialize }
AtomicAtom >> initialize [
	super initialize.
	links := #().
]

{ #category : #testing }
AtomicAtom >> isAtom [
	^ true
]

{ #category : #testing }
AtomicAtom >> isFullyLinked [
	links ifNotNil: [
		"Verifies if all the links are ok"
		(links allSatisfy: [:link | self owner isAtom: self linkedTo: link]) ifFalse: [^ false].
		"If has required links, verify them"
		forcedLinks allSatisfy: [
			:forced | 
			links anySatisfy: [
				:link | 
				self owner isAtomKind: forced fromAtom: self linkedTo: link.
			]
		].
	].
	"no more checks"
	^ true
]

{ #category : #'access properties' }
AtomicAtom >> links: aLinks [
	links := aLinks
]

{ #category : #'access properties' }
AtomicAtom >> previewPosition [
	^ previewPosition
]

{ #category : #'access properties' }
AtomicAtom >> previewPosition: aPosition [
	previewPosition := aPosition
]

{ #category : #initialization }
AtomicAtom >> withMapStyle: aMapStyle links: theLinks forcedLinks: theForcedLinks [ 
	self withMapStyle: aMapStyle.
   links:= theLinks.
	forcedLinks:= theForcedLinks.
	
]
