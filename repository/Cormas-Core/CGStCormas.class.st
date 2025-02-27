"
Code generator for CORMAS 

"
Class {
	#name : #CGStCormas,
	#superclass : #CGStTemplate,
	#instVars : [
		'cormasModel',
		'isMeta'
	],
	#category : #'Cormas-Core-Tools'
}

{ #category : #'instance creation' }
CGStCormas class >> for: aCMProjectModel [
	" Answer a new instance of the recever "
	
	^ self new 
		cormasModel: aCMProjectModel cormasModel;
		yourself
]

{ #category : #'code-generation' }
CGStCormas >> addNewClassType: aType inheritingFrom: aSuperclass name: aName initProtocol: createInit stepProtocol: createStep [
	" aType is a <String> and could be : Social , 
	aName is a validated CORMAS entity (class) name in the format CM<ModelName>UserProvidedEntityName"

	| selector theClass cmClass |
	[ self generateClass: aName superclass: aSuperclass ]
		on: CircularHierarchyError
		do: [ :ex | ^ self inform: 'Trying to build a circular hierarchy' ].

	theClass := self class environment at: aName.
	selector := (aType asLowercase , 'Classes') asSymbol.

	cmClass := self cormasModelClass = UndefinedObject
		ifTrue: [ self targetClass ]
		ifFalse: [ self cormasModelClass ].
	(cmClass perform: selector) add: theClass.
	(theClass inheritsFrom: CMSpatialEntityElement) 
		ifTrue: [ cmClass cellClass: theClass ].
	self createModelAccessorsIn: theClass.
	self addProtocolNamed: #control.
	createInit ifTrue: [ self createInit ].
	createStep ifTrue: [ self createStep ]. "self modifyEntityClassType: aType."
	^ aName
]

{ #category : #'code-generation' }
CGStCormas >> automaticCommentString [
	
	^ '!! This method was automatically generated by Cormas !!'
]

{ #category : #accessing }
CGStCormas >> confirmIsAbstractClass: aClass [

	^ self confirm: (String streamContents: [ : stream | 
		stream 
			<< 'Is ';
			<< aClass name asText;
			<< ' an Abstract class?';
			cr; cr;
			<< ' (an abstract class does not have instance and must have subclasses, while';
			cr;
			<< ' a concret class will have instances and ';
			<< self cormasModelClass name;
			<< ' will define an attribut called ';
			<< aClass asGetterForEntityClass;
			<< ').' ]).
]

{ #category : #accessing }
CGStCormas >> cormasModel [
	^ cormasModel
]

{ #category : #accessing }
CGStCormas >> cormasModel: aCMAbstractModel [

	cormasModel := aCMAbstractModel
]

{ #category : #accessing }
CGStCormas >> cormasModelClass [
	" Answer a <CMAbstractModel> "

	^ self cormasModel class

	
]

{ #category : #'code-generation' }
CGStCormas >> createAttribute: attributeName defaultValue: anObject [
	" Private - Create attributeName <String> in the receiver's targetClass with default value anObject <Object> "

	| srcTemplate |

	self pvtCreateInstanceOrClassAttribute: attributeName defaultValue: anObject.		
	srcTemplate := anObject
		ifNotNil: [ self templateForAttributeGetterWithCormasDefault: attributeName ]
		ifNil: [ self templateForAttribute: attributeName ].
	self 
		targetMethodCategory: 'accessing';
		targetSelector: attributeName;		
		sourceString: srcTemplate;
		generateMethod.
	srcTemplate := self templateForAttributeSetter: attributeName.
	self 
		targetMethodCategory: 'accessing';
		targetSelector: attributeName , ':';		
		sourceString: srcTemplate;
		generateMethod.

	self 
		targetMethodCategory: 'defaults';
		targetSelector: attributeName , '_default';		
		sourceString: (self templateForAttributeGetter: attributeName default: anObject);
		generateMethod.
]

{ #category : #'code-generation' }
CGStCormas >> createInit [
	
	self 
		targetMethodCategory: 'init';
		sourceString: 'init\	"to be completed"\' withCRs;
		generateMethod.

]

{ #category : #'code-generation' }
CGStCormas >> createInitAgents [
	
	self 
		targetMethodCategory: 'init';
		sourceString: 'initAgents\	"to be completed"\' withCRs;
		generateMethod.

]

{ #category : #'code-generation' }
CGStCormas >> createModelAccessorsIn: aClass [
	" Private - Ask if newClass is Abstract, 
	no, then creates the attribut 'theNewClasss' and the accesors at the level of cormasModel,
	yes, then creates an accessing methods 'theNewClass' that will returns a collection of all entities of newClass and its subclasses"
	
	(aClass inheritsFrom: CMSpatialEntityElement)
		ifTrue: [ 
			self installConcreteMethodIn: aClass.
			self createModelInstancesAccessorsIn: aClass ]
		ifFalse: [ (self confirmIsAbstractClass: aClass) 
			ifTrue: [ self installAbstractMethodIn: aClass ]
			ifFalse: [ self createModelInstancesAccessorsIn: aClass ] ].
]

{ #category : #'code-generation' }
CGStCormas >> createModelInstancesAccessorsIn: aClass [
	| pop |
	
	pop := aClass asGetterForEntityClass.
	aClass isAbstract
		ifTrue: [ 
			self targetClass 
				compile: (self templateForModelInstanceAccessors: pop in: aClass)
				classified: 'accessing'
				notifying: nil ]
		ifFalse: [ 
			(self targetClass hasInstVarNamed: pop)
				ifFalse: [ self targetClass addInstVarNamed: pop ].
			self createModelReaderAccessor: aClass.
			self createModelSetterAccessor: aClass ]
]

{ #category : #'code-generation' }
CGStCormas >> createModelReaderAccessor: aClass [
	"creates a reader accessor that returns a Collection. 
aClassName = <String> or <Symbol>.

Ex: #theXXXs 
	''Returns a collection of all the instances of the classe collected by cormasModel.
	!! This method was automatically generated by Cormas !!''
^ theXXXifNil:[theXXX := OrderedCollection new]."

	| pop |
	
	pop := aClass asGetterForEntityClass.
	self targetClass 
		compile: (self templateForModelReaderAccessor: pop)
		classified: 'accessing'
		notifying: nil
]

{ #category : #'code-generation' }
CGStCormas >> createModelSetterAccessor: aClass [
	"creates a setter accessor such as :
theXXXs: aNewCollection 
	theXXXs := aNewCollection.
aClassName = <String> or <Symbol>.
(aClassName ('XXX') is completed as theXXXs)"
	
	| pop |
	pop := aClass asGetterForEntityClass.
	self targetClass 
		compile: (self templateForModelSetterAccessor: pop)
		classified: 'accessing'
		notifying: nil
]

{ #category : #'code-generation' }
CGStCormas >> createPoV [
	
	self 
		targetMethodCategory: 'pov';
		targetSelector: #pov;
		sourceString: 'pov
	" To be completed "
	
' withCRs;
		generateMethod.

]

{ #category : #'code-generation' }
CGStCormas >> createStep [
	
	self
		targetMethodCategory: 'control';
		sourceString: 'step\	"to be completed"' withCRs;
		generateMethod.
]

{ #category : #'code-generation' }
CGStCormas >> generateMethodHeader [
	" Add the selector and comments if configured "
	
	self resetCodeStream.	
	self buildMethodHeader.


]

{ #category : #'code-generation' }
CGStCormas >> installAbstractMethod [
	" Private - isAbstract method should be installed in the new entity class being created "

	self
		targetMethodCategory: 'testing';
		sourceString: 'isAbstract \	^ true' withCRs;
		generateMethod.

]

{ #category : #'code-generation' }
CGStCormas >> installAbstractMethodIn: aClass [
	" Private - isAbstract method should be installed in the new entity class being created "

	self class new
		targetClass: aClass;
		targetSelector: #isAbstract; 	" For compatibility with code generator "
		targetMethodCategory: 'testing';
		sourceString: 'isAbstract \	^ true' withCRs;
		generateMethod.

]

{ #category : #'code-generation' }
CGStCormas >> installConcreteMethod [
	
	self
		targetMethodCategory: 'testing';
		sourceString: 'isAbstract \	^ false' withCRs;
		generateMethod.
]

{ #category : #'code-generation' }
CGStCormas >> installConcreteMethodIn: aClass [
	
	self class new
		targetClass: aClass;
		targetMethodCategory: 'testing';
		targetSelector: #isAbstract;	" For compatibility with Code Generator "
		sourceString: 'isAbstract \	^ false' withCRs;
		generateMethod.
]

{ #category : #accessing }
CGStCormas >> isMeta [
	" If <true>, set the receiver to compile methods using 'self class' where applicable "
	
	^ isMeta
		ifNil: [ isMeta := true ]
]

{ #category : #accessing }
CGStCormas >> isMeta: anObject [

	isMeta := anObject
]

{ #category : #accessing }
CGStCormas >> projectManager [ 

	^ self cormasModel projectManager
]

{ #category : #private }
CGStCormas >> pvtCreateInstanceOrClassAttribute: attributeName defaultValue: anObject [
	" Private - Create the accessor method for attributeName <String> in the receiver's targetClass. "

	self targetClass isMeta
		ifTrue: [ 
			(self targetClass instanceSide hasClassVarNamed: attributeName) 
				ifFalse: [ self targetClass instanceSide addClassVarNamed: attributeName ].
			self isMeta: false ]
		ifFalse: [ 
			(self targetClass hasInstVarNamed: attributeName) ifFalse: [ 
				self targetClass addInstVarNamed: attributeName ] ]
]

{ #category : #accessing }
CGStCormas >> removeAccessors: instVarName [ 
	" Remove both getter and setter for instVarName instance variable name from the receiver's targetClass. Do nothing if there are no accessors in the target class  "

	(self targetClass includesSelector: instVarName)
		ifTrue: [ self targetClass removeSelector: instVarName ].
	(self targetClass includesSelector: instVarName asMutator)
		ifTrue: [ self targetClass removeSelector: instVarName asMutator ]
]

{ #category : #'code-generation' }
CGStCormas >> removeAttribute: attributeName [
	" Private - Remove attributeName <String> in the receiver's targetClass. 
	Also remove the accessors and <attributeName>_default methods if present "

	| attName |
	
	attName := attributeName uncapitalized.
	self removeAccessors: attName.
	self removeDefaultMethod: attName.
	(self targetClass hasInstVarNamed: attributeName)
		ifTrue: [ self removeIVar: attributeName ]
		ifFalse: [ (self targetClass classVarNames includes: attributeName)
			ifTrue: [ self targetClass instanceSide removeClassVarNamed: attributeName ] ]
]

{ #category : #accessing }
CGStCormas >> removeDefaultMethod: instVarName [ 

	self targetSelector: instVarName , '_default'.
	(self targetClass class includesSelector: self targetSelector)
		ifTrue: [ self targetClass: self targetClass class ].
	(self targetClass includesSelector: self targetSelector)
		ifFalse: [ ^ self ].
	self targetClass removeSelector: self targetSelector.
]

{ #category : #accessing }
CGStCormas >> renameClass: oldClassname to: newClassname [ 

	^ self codeTransformer 
		renameClass: oldClassname 
		to: newClassname.
]

{ #category : #'code-generation' }
CGStCormas >> templateForAttribute: attributeName [
	" Answer a <String> representing an accessor method for attributeName "

	^ (String streamContents: [ : stream |
		stream 
			<< attributeName;
			<< '\	"Getter accessor without default value.\';
			<< self automaticCommentString;
			<< '"\	^ ';
			<< attributeName ]) withCRs
]

{ #category : #'code-generation' }
CGStCormas >> templateForAttributeGetter: attributeName default: anObject [
	" Answer a <String> representing an accessor method for attributeName "

	^ (String streamContents: [ : stream |
		stream 
			<< attributeName uncapitalized;		
			<< '_default';
			<< '\	" Answer a default value for the ';
			<< attributeName;
			crtab;
			<< self automaticCommentString;
			<< '"\	^ ';
			<< (self transformAsString: anObject) ]) withCRs
]

{ #category : #'code-generation' }
CGStCormas >> templateForAttributeGetterWithCormasDefault: attributeName [
	" Answer a <String> which is just a template method returning anObject "


	^ (String << [ : stream |
		stream
			<< attributeName uncapitalized;
			<< '\	"Getter accessor with default value';
			<< self automaticCommentString;
			<< '"\	^ ';
			<< attributeName;
			<< ' ifNil: [ ';
			<< attributeName;
			<< ' := self ';
			<< attributeName uncapitalized;
			<< '_default';
			<< ' ]']) withCRs
]

{ #category : #'code-generation' }
CGStCormas >> templateForAttributeSetter: attributeName [
	" Answer a <String> representing an accessor method for attributeName "

	^ (String streamContents: [ : stream |
		stream 
			<< attributeName uncapitalized ;
			<< ': anObject';
			<< '\	" Set a value for the receiver''s ';
			<< attributeName;
			crtab;
			<< self automaticCommentString;
			<< '"\	 ';
			<< attributeName;
			<< ' := anObject' ]) withCRs
]

{ #category : #'code-generation' }
CGStCormas >> templateForModelInstanceAccessors: pop in: aClass [

	^ String streamContents: [ : stream |
		stream 
			<< pop; crtab;
			<< 	'" Returns a collection of all the instances of aClass (and sub classes) collected by cormasModel.'; crtab;
			<< self automaticCommentString; cr; crtab;
			<< '" ^ self allTheEntities: ';
			<< aClass name asString ]

]

{ #category : #'code-generation' }
CGStCormas >> templateForModelReaderAccessor: pop [

	^ String streamContents: [ : stream | 
			stream 
				<< pop; crtab;
				<< '"Returns a collection of all the instances of the sub classes collected by cormasModel.'; crtab;
				<< self automaticCommentString;
				<< $"; cr; crtab;
				<< ' ^ ';
				<< pop; crtab; tab;
				<< ' ifNil: [ '; 
				<< pop;
				<< ' := OrderedCollection new ]'
		 ]

]

{ #category : #'code-generation' }
CGStCormas >> templateForModelSetterAccessor: pop [

	^ String streamContents: [ : stream |
		stream 
			<< pop;
			<< ': aNewCollection'; crtab;
			<< '" Set a new collection for theXXXs attribute.'; crtab;
			<< self automaticCommentString;
			<< $"; cr; crtab;
			<< pop;
			<< ' := aNewCollection.' ]
]

{ #category : #'mustache-templates' }
CGStCormas >> templateForPovOnAttribute: attribute [

	^ 'pov' , attribute capitalized ,
					'\"return the value of the attribute\if the value is a string, converts it to a symbol\if the value is a number, converts it to a symbol, precede by the word {1} "
	self {1} isString ifTrue:[ ^ self {1} asSymbol ].
	self {1}	isLiteral ifTrue:[ ^ (''{1}'' , self {1} printString) asSymbol ].
	^ self {1}' format: { attribute }
]

{ #category : #'code-generation' }
CGStCormas >> transformAsString: defaultValue [
	"return the defaultValue as a string.
	defaultValue: <Number or String or Boolean or Dictionary or Array or Collection>"
	
	| defaultString coll |
	defaultValue isNil ifTrue: [^'nil'].
	defaultValue isString
		ifTrue:
			["((defaultValue findString: 'randomFloat' startingAt: 1) = 1) ifTrue:[^defaultValue].
((defaultValue findString: 'randomInteger' startingAt: 1) = 1) ifTrue:[^defaultValue]."
			^defaultValue printString].
	(defaultValue isKindOf: Boolean) ifTrue: [^defaultValue asString].
	(defaultValue isKindOf: Number) ifTrue: [^defaultValue asString].
	(defaultValue isKindOf: Dictionary)
		ifTrue:
			[defaultValue isEmpty
				ifTrue: [defaultString := defaultValue class name asString , ' new']
				ifFalse: [self halt].
			^defaultString].
	(defaultValue isKindOf: Array)
		ifTrue:
			[defaultString := 'Array withAll: ' , defaultValue asString.
			^defaultString].	"because Array is immutable in VW7.6, cannot write  defaultValue asString !"
	(defaultValue isKindOf: Collection)
		ifTrue:
			[defaultValue isEmpty
				ifTrue: [defaultString := defaultValue class name asString , ' new']
				ifFalse:
					[defaultString := ''.
					coll := defaultValue asString substrings asOrderedCollection.
					coll add: 'withAll:' beforeIndex: 2.
					coll do: [:sub | defaultString := defaultString , sub , ' ']].
			^defaultString].
	^defaultValue asString
]
