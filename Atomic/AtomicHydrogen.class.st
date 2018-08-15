"
Basically Hydrogen atom shows a ""H""
"
Class {
	#name : #AtomicHydrogen,
	#superclass : #AtomicAtom,
	#category : #Atomic
}

{ #category : #'access properties' }
AtomicHydrogen >> atomSymbol [
	^ 'H'
]

{ #category : #initialize }
AtomicHydrogen >> defaultColor [
	^ Color r: 0 g: 0.6 b: 0.0
]
