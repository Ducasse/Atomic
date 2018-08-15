"
Some maps will have a part of a link between atoms to be moved too.
"
Class {
	#name : #AtomicLink,
	#superclass : #AtomicAtom,
	#category : #Atomic
}

{ #category : #'access properties' }
AtomicLink >> atomSymbol [
	^ self error: 'Does not need a symbol'
]

{ #category : #drawing }
AtomicLink >> drawOn: aCanvas [ 
	self drawActivation: aCanvas.
	self drawLinks: aCanvas.

]
