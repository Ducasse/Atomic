"
Basically Nitrogen atom shows an ""N""
"
Class {
	#name : #AtomicNitrogen,
	#superclass : #AtomicAtom,
	#category : #Atomic
}

{ #category : #'access properties' }
AtomicNitrogen >> atomSymbol [
	^ 'N'
]

{ #category : #initialize }
AtomicNitrogen >> defaultColor [
	^ Color r: 0.6 g: 0.6 b: 0
]
