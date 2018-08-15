"
This represents a brick of the wall. Allows to close the maze.
"
Class {
	#name : #AtomicBrick,
	#superclass : #AtomicComponent,
	#category : #Atomic
}

{ #category : #initialize }
AtomicBrick >> defaultColor [
	"Originally... a bit boring... Color lightGray twiceLighter"
	^ AtomicGame pharoMatchDarkColor.
]

{ #category : #drawing }
AtomicBrick >> drawOn: aCanvas [
	| rectBound lineColor |
	"Face of the brick.."
	aCanvas fillRectangle: bounds fillStyle: self defaultColor.

	"Draw shadow effect (light to dark)"
	lineColor := self defaultColor.
	rectBound := bounds insetBy: self howManyShadowLines.
	1 to: self howManyShadowLines do: [ 
		:value | 
		lineColor := lineColor alphaMixed: 0.85 with: self defaultColor negated.
		aCanvas line: rectBound topRight to: rectBound bottomRight color: lineColor.
		aCanvas line: rectBound bottomRight to: rectBound bottomLeft color: lineColor.
		rectBound := rectBound insetBy: -1.
	].

	"Draw light effect (dark to light)"
	lineColor := Color white.
	rectBound := bounds origin corner: bounds corner - 1. "Lines draw inclusive!"
	1 to: self howManyShadowLines do: [ 
		:value | 
		aCanvas line: rectBound bottomLeft to: rectBound topLeft color: lineColor.
		aCanvas line: rectBound topLeft to: rectBound topRight color: lineColor.
		rectBound := rectBound insetBy: 1.
		lineColor := lineColor alphaMixed: 0.8 with: self defaultColor.
	].
]

{ #category : #drawing }
AtomicBrick >> howManyShadowLines [
	^ self isSmallScreen
		ifTrue: [ 0 ]
		ifFalse: [ 4 ]
]

{ #category : #drawing }
AtomicBrick >> shapeSize [
	^ self isSmallScreen
		ifTrue: [ 2 ]
		ifFalse: [ 4 ]
]
