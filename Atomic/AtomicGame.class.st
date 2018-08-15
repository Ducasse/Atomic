"
Atomic Game: Build chemical molecules placing the given atoms using the minimum moves possible. Once an atom or link start moving, it cannot be stopped except if it hits a wall or another atom.
The level is solved when the molecule has the same structure as shown in the preview. Some tactical skill will be necessary for solving the puzzle.
It has been implemented by Gustavo Rafael Pistoia. Some improvements in 2017.

To run the game run:

    AtomicGame new openInWorld.


"
Class {
	#name : #AtomicGame,
	#superclass : #BorderedMorph,
	#instVars : [
		'selected',
		'currentMap',
		'pointsMorph',
		'mapMoves',
		'fastMoves'
	],
	#category : #Atomic
}

{ #category : #'preferences-colors' }
AtomicGame class >> pharoMatchDarkColor [
	^ Color fromHexString: '62A7D1'.
]

{ #category : #'preferences-colors' }
AtomicGame class >> pharoMatchFontColor [
	"Buttons do not allow to change font color so I keep it consistent in the design"
	^ Color black.
]

{ #category : #'preferences-colors' }
AtomicGame class >> pharoMatchLightColor [
	^ Color fromHexString: 'ECF8FF'.
]

{ #category : #actions }
AtomicGame >> activateAtom: atom [
	"Change the currently selected atom"
	selected ifNotNil: [ selected deactivate ].
	selected := atom.
	selected ifNotNil: [ selected activate ].

]

{ #category : #'access properties' }
AtomicGame >> availableMaps [
	^ AtomicMap subclasses. 
	
		
]

{ #category : #structure }
AtomicGame >> buildLevel: aMap [	
	"None active"
	self activateAtom: nil.
	"Clear "
	self removeAllMorphs.

	"Shink this game again"
	bounds := bounds topLeft corner: bounds topLeft.
	
	"Other states"
	mapMoves := 0.
	currentMap := aMap.
	fastMoves ifNil: [ fastMoves := self isSmallScreen ].
	
	"Buidl the whole board.."
	self createTitleBars.
	self createTextBars.
	self createButtonsBar.
	self createPreviewMolecule.
	self createMap.
	self showPointsInfo.
	"Select first atom.."
	self activateAtom: self nextAtom.	
	"repaint.."
	self changed.

]

{ #category : #actions }
AtomicGame >> checkIsCompleted [
	"Checks if the level is completed"
	| map subList hasCompleted |
	subList := self submorphs select: [:each | (each class inheritsFrom: AtomicAtom) and: [ each isPreview not] ].	
	hasCompleted := subList allSatisfy: [:each | each isFullyLinked].	
   hasCompleted ifFalse: [  ^ self. ].

	"Has next map?"
	map := self createNextMap.
	map ifNotNil: [
		"Go to the next level"
		self buildLevel: map.
		"Continue"
		^ self.
	].

	"No selection"
	self activateAtom: nil.
	"Make it pretty"
	pointsMorph color: Color red.
	"show a final message"
	pointsMorph contents: 'YOU WON !!!!!!'.

]

{ #category : #'UI building' }
AtomicGame >> createButtonsBar [
	| delta controlPosition moveStyleButton helpButton prevButton sameButton nextButton quitButton |
	delta := currentMap mapStyle borderSpace x @ 0.
	controlPosition := currentMap mapStyle borderSpace + (bounds origin x @ bounds corner y).
	"Go to previous map"
	prevButton := self createSimpleButton: #goPrevLevel text: 'Previous' hint: 'Jumps to the previous level'.
	self includeMorph: prevButton position: controlPosition.
	"Restart this map"
	controlPosition := controlPosition + delta + (prevButton bounds width @ 0).
	sameButton := self createSimpleButton: #goSameLevel text: 'Reset' hint: 'Restarts this level'.
	self includeMorph: sameButton position: controlPosition.
	"Go to next map"
	controlPosition := controlPosition + delta + (sameButton bounds width@ 0).
	nextButton := self	createSimpleButton: #goNextLevel text: 'Next' hint: 'Jumps to the next level'.
	self includeMorph: nextButton position: controlPosition.
	"Moves style"
	controlPosition := controlPosition + delta + (nextButton bounds width  * 2 @ 0).
	moveStyleButton := self createSwitchButton: #moveStyleState: text: 'Fast'	hint: 'Animate on/off' state: fastMoves.
	self includeMorph: moveStyleButton position: controlPosition.
	"Instructions"
	controlPosition := controlPosition + delta + (moveStyleButton bounds width @ 0).
	helpButton := self createSimpleButton: #showHelpWindow text: 'Help' 	hint: 'Shows instructions'.
	self includeMorph: helpButton position: controlPosition.
	"Close the game"
	controlPosition := controlPosition + delta + (helpButton bounds width @ 0).
	quitButton := self createSimpleButton: #delete text: 'Quit' hint: 'Closes the game'.
	self includeMorph: quitButton position: controlPosition.

]

{ #category : #'UI building' }
AtomicGame >> createFirstMap [
	| maps |
	maps := self availableMaps.
	^ (maps at: 1) new
	
]

{ #category : #'UI building' }
AtomicGame >> createMap [
	currentMap buildLayout: self startOn: (bounds bottomLeft) mapStyle: currentMap mapStyle.

]

{ #category : #'UI building' }
AtomicGame >> createMaze [
	| dx dy |
	currentMap buildLayout: self.
	dx := currentMap neededSize x - bounds width.
	dx > 0
		ifTrue: [bounds := bounds extendBy: dx @ 0].
	dy := currentMap neededSize y.
	bounds := bounds extendBy: 0 @ dy.
	self changed
]

{ #category : #'UI building' }
AtomicGame >> createNextMap [
	| maps mapName index |
	maps := self availableMaps.
	mapName := currentMap class.
	index := maps indexOf: mapName.
	index < maps size ifTrue: [ ^ (maps at: index + 1) new ].
	^ nil.
]

{ #category : #'UI building' }
AtomicGame >> createPrevMap [
	| maps mapName index |
	maps := self availableMaps.
	mapName := currentMap class.
	index := maps indexOf: mapName.
	index > 1 ifTrue: [ ^ (maps at: index - 1) new ].
	^ nil.
]

{ #category : #'UI building' }
AtomicGame >> createPreview [
	| extra |
	currentMap buildLayoutForPreview: self.
	extra := currentMap previewNeededSize x.
	bounds := bounds extendBy: extra @ 0.
	self changed
]

{ #category : #'UI building' }
AtomicGame >> createPreviewMolecule [
	| previewMapStyle |
	previewMapStyle := AtomicMapStyle newForPreview.
	currentMap buildLayout: self startOn: (self bounds topRight) mapStyle: previewMapStyle.
	self changed
]

{ #category : #'UI building' }
AtomicGame >> createSameMap [
	^ currentMap class new

]

{ #category : #'UI building' }
AtomicGame >> createSimpleButton: anAction text: aText hint: aHint [
	| text button |
	text := self isSmallScreen ifTrue: [ aText first asString ] ifFalse: [ aText ].
	button := SimpleButtonMorph newWithLabel: text.
	button target: self.
	button actionSelector: anAction.
	button useSquareCorners.
	button borderWidth: 0.
	button setBalloonText: aHint.
	button color: self class pharoMatchDarkColor lighter.
	^ button.
		
]

{ #category : #'UI building' }
AtomicGame >> createSwitchButton: anAction text: aText hint: aHint state: aBoolean [
	| text button |
	text := self isSmallScreen ifTrue: [ aText first asString ] ifFalse: [ aText ].
	button := SimpleSwitchMorph newWithLabel: text.
	button target: self.
	button actionSelector: anAction.
	button useSquareCorners.
	button borderWidth: 0.
	button setBalloonText: aHint.
	button offColor: self class pharoMatchDarkColor lighter.
	button onColor: self class pharoMatchDarkColor darker.
	button setSwitchState: aBoolean.
	^ button.
]

{ #category : #'UI building' }
AtomicGame >> createTextBars [
	| infoMorph |
	"information"
	infoMorph := StringMorph new contents: self levelMessage.
	infoMorph color: self class pharoMatchFontColor.
	self includeMorph: infoMorph position: (bounds origin x @ bounds corner y + currentMap mapStyle borderSpace).
	"points"
	pointsMorph := StringMorph new contents: 'loading..'.
	pointsMorph color: self class pharoMatchFontColor.
	self includeMorph: pointsMorph position: (bounds origin x @ bounds corner y + currentMap mapStyle borderSpace).

]

{ #category : #'UI building' }
AtomicGame >> createTitleBars [
	| titleMorph |
	titleMorph := StringMorph new contents: ' ATOMIC 2.0'; font: StandardFonts windowTitleFont emphasis: 3.
	titleMorph color: (self class pharoMatchDarkColor alphaMixed: 0.6 with: self class pharoMatchFontColor).
	self includeMorph: titleMorph position: (bounds origin x @ bounds corner y) + (currentMap mapStyle borderSpace).

]

{ #category : #initialization }
AtomicGame >> defaultColor [
	^ self class pharoMatchLightColor
]

{ #category : #'access properties' }
AtomicGame >> fastMoves [
	^ fastMoves
]

{ #category : #structure }
AtomicGame >> getNextPosition: aDirection [ 
	| currentPosition delta morph |
	currentPosition := selected position.
	delta := currentMap mapStyle atomSize * aDirection.
	[morph := self somethingAt: currentPosition + delta.
	morph isNil]
		whileTrue: [currentPosition := currentPosition + delta].
	^ currentPosition
]

{ #category : #structure }
AtomicGame >> goFirstLevel [
	
	self createFirstMap ifNotNil: [:map | self buildLevel: map]
]

{ #category : #structure }
AtomicGame >> goLevel: aMap [
	"Initialization"

	self select: nil.
	self removeAllMorphs.
	mapMoves := 0.
	currentMap := aMap.
	fastMoves ifNil: [ fastMoves := self isSmallScreen ].
	bounds := self position corner: self position.	"creates new controls"
	self createTextBars.
	self createButtonsBar.
	self createMaze.
	self createPreview.	"information"
	self showPointsInfo.	"select the first atom"
	self select: self nextAtom
]

{ #category : #structure }
AtomicGame >> goNextLevel [

	self createNextMap ifNotNil: [:map | self buildLevel: map ]
]

{ #category : #structure }
AtomicGame >> goPrevLevel [
	self createPrevMap ifNotNil: [:map | self buildLevel: map]
]

{ #category : #structure }
AtomicGame >> goSameLevel [
	self createSameMap ifNotNil: [:map | self buildLevel: map]
]

{ #category : #'event handling' }
AtomicGame >> handlesKeyboard: evt [
	^ currentMap isNotNil
]

{ #category : #'event handling' }
AtomicGame >> handlesMouseDown: evt [ 
	| morph movable |
	morph := self somethingAt: evt position.
	movable := morph notNil and: [morph isMovable].
	movable ifFalse: [self activateAtom: nil].
	^ movable
]

{ #category : #'event handling' }
AtomicGame >> handlesMouseOver: evt [
	^ currentMap isNotNil

]

{ #category : #structure }
AtomicGame >> includeMorph: aMorph position: aPosition [
	| morphGap |
	aMorph position: aPosition.
	morphGap := aMorph bounds corner + currentMap mapStyle borderSpace.
	bounds := bounds origin corner: (bounds corner max: morphGap).
	self addMorph: aMorph.
	
]

{ #category : #initialization }
AtomicGame >> initialize [
	super initialize.
	self position: 50 @ 50.
	self goFirstLevel
]

{ #category : #testing }
AtomicGame >> isAtom: aAtom linkedTo: aLink [ 
	| currentPosition delta |
	currentPosition := aAtom position.
	delta := currentMap mapStyle atomSize * aLink.
	^ self isAtomAt: currentPosition + delta
]

{ #category : #testing }
AtomicGame >> isAtomAt: aPosition [ 
	| morph |
	morph := self somethingAt: aPosition.
	^ morph notNil and: [ morph isAtom ]
]

{ #category : #testing }
AtomicGame >> isAtomKind: aKind at: aPosition [ 
	| morph |
	morph := self somethingAt: aPosition.
	^ morph class inheritsFrom: aKind
]

{ #category : #testing }
AtomicGame >> isAtomKind: aKind fromAtom: aAtom linkedTo: aLink [ 
	| currentPosition delta |
	currentPosition := aAtom position.
	delta := currentMap mapStyle atomSize * aLink.
	^ self isAtomKind: aKind at: currentPosition + delta
]

{ #category : #'UI building' }
AtomicGame >> isSmallScreen [
	^ currentMap mapStyle isSmallScreen
]

{ #category : #'event handling' }
AtomicGame >> keyStroke: evt [ 
	| charValue |	
	charValue := evt keyCharacter asciiValue.
	"Tab pressed"
	(charValue = 9) ifTrue: [self activateAtom: self nextAtom].
	"This keys requires something selected"
	selected	ifNotNil: [
		"Left pressed"
		charValue = 28 ifTrue: [self makeMovement: -1 @ 0].
		"Right pressed"
		charValue = 29 ifTrue: [self makeMovement: 1 @ 0].
		"Up pressed"
		charValue = 30 ifTrue: [self makeMovement: 0 @ -1].
		"Down pressed"
		charValue = 31 ifTrue: [self makeMovement: 0 @ 1]
	].

]

{ #category : #'access properties' }
AtomicGame >> levelMessage [
	| number message |
	number := self availableMaps indexOf: currentMap class.
	message := 'Level ' , number asString.
	self isSmallScreen
		ifFalse: [ message := message , ': ' , currentMap levelName , '.'].
	^ message
]

{ #category : #actions }
AtomicGame >> makeMovement: aDirection [ 
	selected canBeProgrammed ifFalse: [ ^ self ].
	"Increase the movements counter"
	mapMoves := mapMoves + 1.
	self showPointsInfo.
	selected startMovement: (self getNextPosition: aDirection).
]

{ #category : #'event handling' }
AtomicGame >> mouseDown: evt [ 	
	self activateAtom: (self somethingAt: evt position)
]

{ #category : #'event handling' }
AtomicGame >> mouseEnter: evt [
	evt hand newKeyboardFocus: self
]

{ #category : #structure }
AtomicGame >> moveStyleState: aState [ 
	fastMoves := aState
]

{ #category : #'access properties' }
AtomicGame >> nextAtom [
	| current morph |
	current := 0.
	selected ifNotNil: [ current := submorphs indexOf: selected ].
	"get the next atom"
	current + 1 to: submorphs size	do: [
		:index | 
		morph := submorphs at: index.
		((morph class inheritsFrom: AtomicAtom) and: [ morph isMovable ]) ifTrue: [ ^ morph ] .
	].
	"nothing"
	^ nil
]

{ #category : #structure }
AtomicGame >> pointsMessage [
	| message |
	message := 'Best record: ' , currentMap record asString , '.'.
	message := message , '  Your moves: ' , mapMoves asString , '.'.
	^ message
]

{ #category : #actions }
AtomicGame >> select: atom [
	"Change the currently selected atom"

	selected == atom
		ifFalse: [ 
			selected ifNotNil: [ selected deactivate ].
			selected := atom.
			selected ifNotNil: [ selected activate ] ]
]

{ #category : #structure }
AtomicGame >> showHelpWindow [
	"Display a brief info"
	| info dialog |
	info := 
'Instructions:
  The aim of ATOMIC is to build chemical molecules using the given atoms. Each level is solved when the new molecule has the same structure as shown in the preview (on the top right side).
  Clicking on an atom will select it, same as if you press [TAB] key. Use the cursor keys to move the atom, which will only stop when collides with another atom or hit the wall.

Controls:
	[Tab]..... Selects the next atom.
	[Cursor].. Move the selected atom on that direction.

	[Prev].... Goes to previous level.
	[Reset]... Restarts to the current level.
	[Next].... Jumps to the next level.
	[Fast].... Speed when moving the atom.
	[Quit].... Leaves the game.

Dedicated to:
	Smalltalk & Linux Communities.

Thanks for your help:
	Diego Gomez Deck.
 	Alejandro Reimondo.
	Andreas Wüst.
	Stephane Ducasse.
	Esteban Lorenzano.
		
Implemented By:
	Gustavo Rafael Pistoia.
'.
		
	dialog := AboutDialogWindow new.
	dialog textFont: StandardFonts codeFont.
	dialog text: info.
	dialog openInWorld.


]

{ #category : #structure }
AtomicGame >> showPointsInfo [
	pointsMorph contents: self pointsMessage.
	mapMoves = currentMap record
		ifTrue: [pointsMorph color: Color blue]
		ifFalse: [mapMoves - 1 = currentMap record
				ifTrue: [pointsMorph color: Color red]]
]

{ #category : #'access properties' }
AtomicGame >> somethingAt: aPosition [ 
	| morphs morph |
	morphs := self rootMorphsAt: aPosition.
	morphs isEmpty ifTrue: [ ^ nil. ].
	morph := morphs at: 1.
	(morph class inheritsFrom: AtomicComponent) ifTrue: [ ^ morph. ].
	^ nil
]
