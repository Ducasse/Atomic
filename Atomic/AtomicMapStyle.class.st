"
Configuration object to know if the map is for a preview, small screen or normal-size map.

"
Class {
	#name : #AtomicMapStyle,
	#superclass : #Object,
	#instVars : [
		'isPreview',
		'smallScreen'
	],
	#category : #Atomic
}

{ #category : #'instance creation' }
AtomicMapStyle class >> newForPreview [
	^  self new isPreview: true.
	
]

{ #category : #'access properties' }
AtomicMapStyle >> atomPosition: indexes [ 
	^ (self atomSize * indexes) + self borderSpace
]

{ #category : #'access properties' }
AtomicMapStyle >> atomSize [
	^ (isPreview | smallScreen)
		ifTrue: [ 22 @ 22 ]
		ifFalse: [ 40 @ 40 ]
]

{ #category : #'access properties' }
AtomicMapStyle >> borderSpace [
	^ 5 @ 5.
]

{ #category : #initialization }
AtomicMapStyle >> initialize [
	smallScreen := DisplayScreen actualScreenSize < (400 @ 400).
	isPreview := false
]

{ #category : #testing }
AtomicMapStyle >> isPreview [
	^ isPreview 
]

{ #category : #testing }
AtomicMapStyle >> isPreview: aBoolean [
	isPreview := aBoolean.
]

{ #category : #testing }
AtomicMapStyle >> isSmallScreen [
	^ smallScreen
]
