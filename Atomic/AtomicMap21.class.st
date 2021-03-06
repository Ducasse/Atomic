"
To build Ethylic Acetate molecule
"
Class {
	#name : #AtomicMap21,
	#superclass : #AtomicMap,
	#category : #Atomic
}

{ #category : #'element creation' }
AtomicMap21 >> createLayout [
	layout := Matrix rows: 13 columns: 13.
	layout atRow: 1 put: #(1 1 1 1 1 1 1 1 1 1 1 1 1 ).
	layout atRow: 2 put: #(1 0 0 1 1 0 1 0 1 1 0 0 1 ).
	layout atRow: 3 put: #(1 0 0 0 1 0 #(#H 2 3 #n) 0 1 0 0 0 1 ).
	layout atRow: 4 put: #(1 0 0 0 0 #(#C 2 2 #n #s #e #w) 0 0 0 #(#C 5 2 #n #s #e #w) 0 #(#C 6 2 #n #s #e #w) 1 ).
	layout atRow: 5 put: #(1 1 0 0 1 0 0 0 1 0 0 1 1 ).
	layout atRow: 6 put: #(1 #(#O 4 2 #e #w) 0 1 1 #(#C 3 2 #n #n #e #w #C #O) 0 0 1 1 0 0 1 ).
	layout atRow: 7 put: #(1 #(#H 7 2 #w) 0 0 0 0 1 0 0 0 0 0 1 ).
	layout atRow: 8 put: #(1 0 0 1 1 0 0 0 1 1 0 0 1 ).
	layout atRow: 9 put: #(1 1 0 0 1 #(#H 2 1 #s) #(#H 5 1 #s) 0 1 #(#H 5 3 #n) 0 1 1 ).
	layout atRow: 10 put: #(1 0 0 0 #(#H 6 1 #s) 0 0 0 0 0 0 0 1 ).
	layout atRow: 11 put: #(1 0 0 #(#O 3 1 #s #s) 1 0 0 #(#H 1 2 #e) 1 0 0 0 1 ).
	layout atRow: 12 put: #(1 0 #(#H 6 3 #n) 1 1 0 1 0 1 1 0 0 1 ).
	layout atRow: 13 put: #(1 1 1 1 1 1 1 1 1 1 1 1 1 ).
	^ layout
]

{ #category : #'access properties' }
AtomicMap21 >> levelName [
	^ 'Ethylic Acetate'
]

{ #category : #'access properties' }
AtomicMap21 >> record [
	^ 115
]
