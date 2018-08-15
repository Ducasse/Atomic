"
Basically Carbon atom shows a ""C""
"
Class {
	#name : #AtomicCarbon,
	#superclass : #AtomicAtom,
	#category : #Atomic
}

{ #category : #'access properties' }
AtomicCarbon >> atomSymbol [
	^ 'C'
]

{ #category : #initialize }
AtomicCarbon >> defaultColor [
	^ Color r: 0 g: 0 b: 0.6
]
