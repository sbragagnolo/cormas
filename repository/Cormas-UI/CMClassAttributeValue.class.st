Class {
	#name : #CMClassAttributeValue,
	#superclass : #Object,
	#instVars : [
		'targetClass',
		'targetAttribute',
		'currentValue',
		'valueType',
		'hasBeenModified',
		'isHidden',
		'randInteger',
		'maxValueHolder',
		'minValueHolder',
		'intOrFloat',
		'upperConstraint',
		'lowerConstraint',
		'setNotification',
		'setterAccessor',
		'typeOfValue',
		'defaultValueHolder',
		'randomValueHolder',
		'getterAccessor',
		'entityInstances'
	],
	#category : #'Cormas-UI-Spec1-Attributes'
}

{ #category : #new }
CMClassAttributeValue class >> newClass: aClass attribute: attributeSymbol value: value [
	
	| inst |
	inst := self new.
	inst setClass: aClass attribut: attributeSymbol value: value.
	^inst
]

{ #category : #actions }
CMClassAttributeValue >> accept [
	"This stub method was generated by UIDefiner"
	
	^self
]

{ #category : #actions }
CMClassAttributeValue >> acceptValue [
	
	| value |
	value := self defaultValueHolder value.
	self typeOfValue value = #randomValue
		ifFalse:
			[self valueType: value class.
			self currentValue: value].
	self hasBeenModified: true	"	self closeAndUnschedule.
	^self closeRequest"
]

{ #category : #'access as String' }
CMClassAttributeValue >> asString [
	"Ex: 'Predator_energy: 12'  "
	
	^self classNameAsString , '_' , self attributeAsString , ': '
		, self currentValueAsString
]

{ #category : #'access as String' }
CMClassAttributeValue >> attributeAsString [
	
	^self targetAttribute
]

{ #category : #'access as String' }
CMClassAttributeValue >> classNameAsString [
	
	^self targetClass name
]

{ #category : #compiling }
CMClassAttributeValue >> compileDefaultValue [
	"Save definitively the changed parameters with the Initial value: compiles the attribute reader accessor and compiles the attribute_default method"
	
	self createAttribute.
	self valueType = Random ifTrue: [self addRandomAttribute].	"Building the Setter method code"
	self setterAccessor value
		ifTrue:
			[self setNotification value
				ifFalse:
					[DefaultAttributesSetter
						defineSetterMethod: self targetAttribute
						ofClass: self targetClass
						protocol: 'accessing']
				ifTrue:
					[DefaultAttributesSetter
						defineSetterMethodWithObserverNotification: self targetAttribute
						ofClass: self targetClass
						protocol: 'accessing']].	"Building the getter method code"	"self getterAccessor value ifFalse: [^nil] on interdit de ne pas avoir de getter"	"Warning accessor already exist"	"getterMethod := self targetAttribute asSymbol.
	(self targetClass canUnderstand: getterMethod)
		ifTrue:
			[(self confirmRedefine) ifFalse: [^nil]]."
	DefaultAttributesSetter defineGetterMethodFrom: self protocol: 'accessing'.
	DefaultAttributesSetter
		defineDefaultClassMethod: self targetAttribute
		ofClass: self targetClass
		withDefaultValue: self currentValue.
	self setAttributeNewValue
]

{ #category : #accessing }
CMClassAttributeValue >> currentValue [
	
	^currentValue
]

{ #category : #accessing }
CMClassAttributeValue >> currentValue: anObject [
	"self hasBeenModified: (currentValue = anObject) not."
	
	currentValue := anObject.
	self valueType = Random ifFalse: [valueType := anObject class].
	^anObject
]

{ #category : #'access as String' }
CMClassAttributeValue >> currentValueAsString [
	
	(currentValue isKindOf: CMClassAttributeValue) ifTrue: [^nil].
	self currentValue isSymbol ifTrue: [^self currentValue printString].
	self currentValue isString ifTrue: [^self currentValue printString].
	^self currentValue asString
]

{ #category : #'access as String' }
CMClassAttributeValue >> currentValueAsString: anObject [
	anObject isNil
		ifTrue:
			[ "text := 'Undefined Object.\\Please use quote for a string (ex: ''Zorba'') \\If ' withCRs asText.
text := text, (self targetAttribute asText emphasizeAllWith: #(#bold #italic #color -> ColorValue red)).
text := text, ' is without default value, write ' asText.
text := text, ('''nil''' asText emphasizeAllWith: #(#bold)).
text := text, ' (with quote). \If ' withCRs.
text := text, (self targetAttribute asText emphasizeAllWith: #(#bold #italic #color -> ColorValue red)).
text := text, ' is a random value, write ' asText.
text := text, ('''random''' asText emphasizeAllWith: #(#bold)).
text := text, ' (with quote).' withCRs.
^Dialog warn: text" ^ nil ].
	self hasBeenModified: currentValue ~= anObject.
	(anObject isString
		and: [ (anObject findString: 'random' startingAt: 1) = 1 ])
		ifTrue: [ | theClass |
			"test if already defined"
			theClass := targetClass isMeta
				ifTrue: [ targetClass soleInstance ]
				ifFalse: [ targetClass ].
			(theClass
				hasRandomAttribute: targetAttribute
				classVariable: targetClass isMeta
				value: anObject)
				ifFalse: [ ^ self chooseRandomness ] ].
	(anObject isKindOf: Array)
		ifTrue: [ ^ self currentValue: (Array withAll: anObject) ].
	anObject = 'nil'
		ifTrue: [ ^ self currentValue: nil ].
	^ self currentValue: anObject
]

{ #category : #aspects }
CMClassAttributeValue >> defaultValueHolder [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^defaultValueHolder isNil
		ifTrue: [defaultValueHolder := nil asValue]
		ifFalse: [defaultValueHolder]
]

{ #category : #accessing }
CMClassAttributeValue >> entityInstances [
	
	^entityInstances
]

{ #category : #accessing }
CMClassAttributeValue >> entityInstances: anObject [
	
	entityInstances := anObject
]

{ #category : #aspects }
CMClassAttributeValue >> getterAccessor [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^getterAccessor isNil
		ifTrue: [getterAccessor := true asValue]
		ifFalse: [getterAccessor]
]

{ #category : #accessing }
CMClassAttributeValue >> hasBeenModified [
	
	^hasBeenModified ifNil: [hasBeenModified := false]
]

{ #category : #accessing }
CMClassAttributeValue >> hasBeenModified: anObject [
	
	hasBeenModified := anObject
]

{ #category : #'initialize-release' }
CMClassAttributeValue >> initialize [
	
"	self intOrFloat onChangeSend: #rangeConstraintsChanged to: self.
	self typeOfValue onChangeSend: #typeChanged to: self."
	^super initialize
]

{ #category : #aspects }
CMClassAttributeValue >> intOrFloat [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^intOrFloat isNil
		ifTrue: [intOrFloat := #randomFloat asValue]
		ifFalse: [intOrFloat]
]

{ #category : #testing }
CMClassAttributeValue >> isClassSide [

	^ self targetClass notNil and: [ self targetClass isMeta ]
]

{ #category : #accessing }
CMClassAttributeValue >> isHidden [
	
	^isHidden ifNil: [isHidden := false]
]

{ #category : #accessing }
CMClassAttributeValue >> isHidden: anObject [
	
	isHidden := anObject
]

{ #category : #aspects }
CMClassAttributeValue >> lowerConstraint [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^lowerConstraint isNil
		ifTrue: [lowerConstraint := ']' asValue]
		ifFalse: [lowerConstraint]
]

{ #category : #aspects }
CMClassAttributeValue >> maxValueHolder [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^maxValueHolder isNil
		ifTrue: [maxValueHolder := 1 asValue]
		ifFalse: [maxValueHolder]
]

{ #category : #aspects }
CMClassAttributeValue >> minValueHolder [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^minValueHolder isNil
		ifTrue: [minValueHolder := 0 asValue]
		ifFalse: [minValueHolder]
]

{ #category : #printing }
CMClassAttributeValue >> printOn: aStream [

	aStream
		<< 'Class: ';
		<< targetClass asString;
		tab;
		<< '[Attribute: ';
		<< targetAttribute asString;
		<< ']';
		tab;
		<< 'Value: ';
		<< currentValue asString
]

{ #category : #'access as String' }
CMClassAttributeValue >> randomAsString [
	"'example: 'randFloat: ]0 ; 10.2['   "
	
	| text |
	text := self intOrFloat value asString , ': '.
	text := text , self lowerConstraint value.
	text := text , self minValueHolder value printString , ' ; '.
	text := text , self maxValueHolder value printString.
	text := text , self upperConstraint value.
	^text
]

{ #category : #random }
CMClassAttributeValue >> rangeConstraintsChanged [
	
	self intOrFloat value = #randomFloat
		ifTrue:
			[upperConstraint value: '['.
			lowerConstraint value: ']']
		ifFalse:
			[upperConstraint value: ']'.
			lowerConstraint value: '[']
]

{ #category : #random }
CMClassAttributeValue >> removeRandomAttribute [
	"' Compile #randomAttributes as class method into targetClass by removing an array: #(#attribute scopeLevel #randFloat min max) "
	
	| aList theClass |
	self targetClass isMeta
		ifTrue:
			[theClass := self targetClass soleInstance.
			aList := Array
				with: self targetAttribute
				with: #class
				with: self intOrFloat value]
		ifFalse:
			[theClass := self targetClass.
			aList := Array
				with: self targetAttribute
				with: #instance
				with: self intOrFloat value].
	aList
		add: self minValueHolder value;
		add: self maxValueHolder value.
	theClass removeRandomAttributes: (Array withAll: aList)
]

{ #category : #actions }
CMClassAttributeValue >> setAttributeInitialValue [
	"reset the parameter of the target classe to nil, then calls the attribut reader accessors to set the initial value"
	
	| writeAccessor allInstances |
	writeAccessor := (self targetAttribute , ':') asSymbol.
	allInstances := self targetClass allInstances.
	allInstances isEmpty
		ifTrue:
			[allInstances := OrderedCollection with: self targetClass basicNew].
	allInstances
		do:
			[:instance | 
			instance perform: writeAccessor with: nil.
			self currentValue: (instance perform: self targetAttribute)].
	self hasBeenModified: false.
	self setAttributeNewValue
]

{ #category : #actions }
CMClassAttributeValue >> setAttributeNewValue [
	"set the attribut (of targetAttribute) to its new value (currentValue) by calling the writter accessor of the attribute"
	
	| writeAccessor allInstances |
	writeAccessor := (self targetAttribute , ':') asSymbol.
	allInstances := self entityInstances
		ifNil: [self targetClass allInstances].
	self valueType = Random
		ifTrue:
			[allInstances do: [:instance | instance perform: writeAccessor with: nil]]
		ifFalse:
			[allInstances
				do:
					[:instance | 
					instance
						perform: writeAccessor
						with: self currentValue]]
]

{ #category : #actions }
CMClassAttributeValue >> setClass: class attribut: attrib value: valor [
	
	| theClass |
	targetClass := class.
	targetAttribute := attrib.
	theClass := class isMeta
		ifTrue: [ class soleInstance ]
		ifFalse: [ class ].
	(theClass
		isRandomAttribute: targetAttribute
		classVariable: (theClass = class) not) ifTrue: [^valueType := Random].
	theClass isGenericEntity
		ifTrue: [currentValue := valor]
		ifFalse:
			[(class instVarNames includes: attrib asString)
				ifFalse: [currentValue := valor]
				ifTrue: [currentValue := self currentValueAsString: valor]].
	valor isString
		ifTrue:
			[(valor findString: 'random' startingAt: 1) = 1
				ifTrue: [^valueType := Random]].
	valueType := valor class
]

{ #category : #aspects }
CMClassAttributeValue >> setNotification [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^setNotification isNil
		ifTrue: [setNotification := false asValue]
		ifFalse: [setNotification]
]

{ #category : #aspects }
CMClassAttributeValue >> setterAccessor [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^setterAccessor isNil
		ifTrue: [setterAccessor := true asValue]
		ifFalse: [setterAccessor]
]

{ #category : #accessing }
CMClassAttributeValue >> targetAttribute [
	
	^targetAttribute
]

{ #category : #accessing }
CMClassAttributeValue >> targetAttribute: anObject [
	
	targetAttribute := anObject
]

{ #category : #accessing }
CMClassAttributeValue >> targetClass [
	
	^targetClass
]

{ #category : #accessing }
CMClassAttributeValue >> targetClass: anObject [
	
	targetClass := anObject
]

{ #category : #actions }
CMClassAttributeValue >> testIfModified [
	"test If the parameter initial value has been modified, then store information in hasBeenModified "
	
	| default initial |
	self valueType = Random ifTrue: [^self hasBeenModified: false].
	default := DefaultAttributesSetter
		getDefaultValueOfAttribut: self targetAttribute
		ofClass: self targetClass.
	initial := DefaultAttributesSetter
		getInitialValueOfAttribut: self targetAttribute
		ofClass: self targetClass.
	default = initial
		ifTrue: [self hasBeenModified: false]
		ifFalse:
			[default isNil
				ifTrue: [self hasBeenModified: false]
				ifFalse:
					[default class = initial class
						ifFalse:
							[self hasBeenModified: true.
							^true].
					default cormasHelper isTypeSet
						ifTrue:
							[self
								hasBeenModified:
									(default cormasHelper elementsOf: default equalElemenstOf: initial) not]
						ifFalse: [self hasBeenModified: true]]].
	^self hasBeenModified
]

{ #category : #aspects }
CMClassAttributeValue >> typeOfValue [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^typeOfValue isNil
		ifTrue: [typeOfValue := #fixedValue asValue]
		ifFalse: [typeOfValue]
]

{ #category : #aspects }
CMClassAttributeValue >> upperConstraint [
	"This method was generated by UIDefiner.  Any edits made here
	may be lost whenever methods are automatically defined.  The
	initialization provided below may have been preempted by an
	initialize method."
	
	^upperConstraint isNil
		ifTrue: [upperConstraint := '[' asValue]
		ifFalse: [upperConstraint]
]

{ #category : #accessing }
CMClassAttributeValue >> valueType [
	
	^valueType
]

{ #category : #accessing }
CMClassAttributeValue >> valueType: anObject [
	
	valueType := anObject
]
