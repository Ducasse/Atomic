"
Basically Oxygen atom shows an ""O""
"
Class {
	#name : #AtomicOxygen,
	#superclass : #AtomicAtom,
	#category : #Atomic
}

{ #category : #'access properties' }
AtomicOxygen >> atomSymbol [
	^ 'O'
]

{ #category : #initialize }
AtomicOxygen >> defaultColor [
	^ Color r: 0.6 g: 0 b: 0.0
]
