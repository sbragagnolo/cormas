Class {
	#name : #CMSpChartProbesMinMaxPresenter,
	#superclass : #CMSpPresenter,
	#instVars : [
		'fixMinCheckPresenter',
		'fixMaxCheckPresenter',
		'scalePresenter',
		'fixMaxInputPresenter',
		'fixMinInputPresenter',
		'minTime'
	],
	#category : #'Cormas-UI-Roassal3-Chart'
}

{ #category : #specs }
CMSpChartProbesMinMaxPresenter class >> defaultSpec [ 

	^ SpBoxLayout newVertical 
		add: #scalePresenter height: self inputTextHeight;
		add: (SpPanedLayout newHorizontal 
			add: #fixMinCheckPresenter;
			add: #fixMinInputPresenter;
			yourself);
		add: (SpPanedLayout newHorizontal 
			add: #fixMaxCheckPresenter;
			add: #fixMaxInputPresenter;
			yourself);
		yourself

]

{ #category : #'accessing - time' }
CMSpChartProbesMinMaxPresenter >> finalTime [
	" Answer a <Number> with the final simluation step time of the receiver's model "

	^ self simManager finalTime
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixMaxCheckPresenter [

	^ fixMaxCheckPresenter
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixMaxCheckPresenter: anObject [

	fixMaxCheckPresenter := anObject
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixMaxInputPresenter [

	^ fixMaxInputPresenter
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixMaxInputPresenter: anObject [

	fixMaxInputPresenter := anObject
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixMinCheckPresenter [

	^ fixMinCheckPresenter
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixMinCheckPresenter: anObject [

	fixMinCheckPresenter := anObject
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixMinInputPresenter [

	^ fixMinInputPresenter
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixMinInputPresenter: anObject [

	fixMinInputPresenter := anObject
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixedMaxYValue [ 
	" Answer a <Number> entered for the maximum Y value in the chart "
	
	^ self fixMaxInputPresenter text asNumber
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> fixedMinYValue [ 
	" Answer a <Number> entered for the minimum Y value in the chart "

	^ self fixMinInputPresenter text asNumber
]

{ #category : #initialization }
CMSpChartProbesMinMaxPresenter >> initializePresenter [ 
 
	fixMinCheckPresenter := self newCheckBox 
		label: 'Fix min to'; 
		state: false;
		whenChangedDo: [ fixMinCheckPresenter toggleState ];
		yourself.
	fixMinInputPresenter := self newTextInput text: self minTime asString; yourself.
	
	fixMaxCheckPresenter := self newCheckBox 
		label: 'Fix max to'; 
		state: false;
		whenChangedDo: [ fixMaxCheckPresenter toggleState ];		
		yourself.
	fixMaxInputPresenter := self newTextInput text: self finalTime asString; yourself.
	
	scalePresenter := self newCheckBox label: 'Scale to min max'; yourself.

]

{ #category : #'accessing - time' }
CMSpChartProbesMinMaxPresenter >> minTime [

	^ minTime
		ifNil: [ minTime := 0 ]
]

{ #category : #'accessing - time' }
CMSpChartProbesMinMaxPresenter >> minTime: anObject [

	minTime := anObject
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> scalePresenter [

	^ scalePresenter
]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> scalePresenter: anObject [

	scalePresenter := anObject
]

{ #category : #initialization }
CMSpChartProbesMinMaxPresenter >> scaleToMinMax [
	" Answer <true> if the receiver option to scale to entered min and max values is checked "

	^ scalePresenter state

]

{ #category : #accessing }
CMSpChartProbesMinMaxPresenter >> simManager [
	" Answer the receiver's <CMSimManager> "
	
	^ self cormasModel simManager

]
