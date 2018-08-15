"
I represent an object in the map, such as a brick, an atom or a missing link.

"
Class {
	#name : #AtomicComponent,
	#superclass : #BorderedMorph,
	#instVars : [
		'isActive',
		'isMoving',
		'mapStyle',
		'futurePosition'
	],
	#category : #Atomic
}

{ #category : #operations }
AtomicComponent >> activate [
	isActive := true.
	self changed.
]

{ #category : #testing }
AtomicComponent >> canBeProgrammed [
	^ isMoving not
]

{ #category : #operations }
AtomicComponent >> deactivate [
	isActive := false.
	self changed
]

{ #category : #'stepping and presenter' }
AtomicComponent >> doMovement [
	| distances direction |
	self position: (
		owner fastMoves
			ifTrue: [ futurePosition ]
			ifFalse: [
				distances := futurePosition - self position.
				direction := distances x sign @ distances y sign.
				self position + (direction + (distances // 6))
			]
		).
]

{ #category : #drawing }
AtomicComponent >> drawActivation: aCanvas [
	| newBound |
	"When is active has a border"
	isActive ifFalse: [ ^ self ].
	"3D style.."
	newBound := bounds origin corner: (bounds corner - 1).
	"Is a bit of 3D shadow and less perfect"
	aCanvas frameRectangle: (newBound translateBy: 1) color: Color gray twiceLighter.
	"The frame in the very border"
	aCanvas frameRectangle: newBound color: Color cyan.

]

{ #category : #initialize }
AtomicComponent >> initialize [
	super initialize.
	isActive := false.
	isMoving := false
]

{ #category : #testing }
AtomicComponent >> isAtom [
	^ false
]

{ #category : #testing }
AtomicComponent >> isFullyLinked [
	^ false
]

{ #category : #testing }
AtomicComponent >> isMovable [
	^ mapStyle isPreview not
]

{ #category : #testing }
AtomicComponent >> isPreview [
	"Return whether the receiver is used to display the molecule that should be assembled."
	^ mapStyle isPreview
]

{ #category : #testing }
AtomicComponent >> isSmallScreen [
	^ mapStyle isSmallScreen
]

{ #category : #accessing }
AtomicComponent >> mapStyle [
	^ mapStyle
]

{ #category : #accessing }
AtomicComponent >> mapStyle: aMapStyle [
	mapStyle := aMapStyle
]

{ #category : #'stepping and presenter' }
AtomicComponent >> startMovement: aNewPosition [ 
	futurePosition := aNewPosition.
	isMoving := true.
	self startStepping
]

{ #category : #'stepping and presenter' }
AtomicComponent >> step [
	futurePosition = self position ifTrue: [ self stopMovement ] ifFalse: [ self doMovement ]
]

{ #category : #'model - stepping' }
AtomicComponent >> stepTime [
	^ 15
]

{ #category : #'stepping and presenter' }
AtomicComponent >> stopMovement [
	isMoving := false.
	futurePosition := nil.
	self stopStepping.
	self owner checkIsCompleted
]

{ #category : #'stepping and presenter' }
AtomicComponent >> wantsSteps [
	^ isMoving
]

{ #category : #initialization }
AtomicComponent >> withMapStyle: aMapStyle [
	isActive := false.
	isMoving := false.
	mapStyle := aMapStyle.
	futurePosition := nil.
]
