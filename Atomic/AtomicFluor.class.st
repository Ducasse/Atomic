"
Basically Fluor atom shows an ""F""
"
Class {
	#name : #AtomicFluor,
	#superclass : #AtomicAtom,
	#category : #Atomic
}

{ #category : #'access properties' }
AtomicFluor >> atomSymbol [
	^ 'F'
]

{ #category : #initialize }
AtomicFluor >> defaultColor [
	^ Color r: 1 g: 0 b: 0.4
]
