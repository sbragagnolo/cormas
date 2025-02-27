"
CMOpenProjectWindow new openWithSpec
"
Class {
	#name : #CMSpOpenProjectPresenter,
	#superclass : #CMSpPManagedPresenter,
	#instVars : [
		'projectsListPresenter',
		'versionsListPresenter',
		'previewPresenter',
		'metaInfoPresenter',
		'cormasProjects',
		'toolbar',
		'projectsLocationsPresenter'
	],
	#category : #'Cormas-UI-Spec2-Project'
}

{ #category : #specs }
CMSpOpenProjectPresenter class >> defaultSpec [

	<spec>
	^ SpBoxLayout newHorizontal
		  add: (SpBoxLayout newVertical
				   add: #projectsLocationsPresenter
				   withConstraints: [ :constraints | 
					   constraints height: self toolbarHeight ];
				   add: #projectsListPresenter;
					yourself);
		  add: (SpPanedLayout newVertical
				   positionOfSlider: 45 percent;
				   add: (SpBoxLayout newHorizontal
						    add: #versionsListPresenter
						    withConstraints: [ :constraints | constraints width: 150 ];
						    add: #previewPresenter;
						    yourself);
				   add: (SpBoxLayout newVertical
						    add: #metaInfoPresenter;
						    add: #toolbar
						    withConstraints: [ :constraints | 
							    constraints height: self toolbarHeight ];
						    yourself);
					yourself);
			yourself
]

{ #category : #examples }
CMSpOpenProjectPresenter class >> example [
	<example>

	CMSpOpenProjectPresenter new openWithSpec
]

{ #category : #specs }
CMSpOpenProjectPresenter class >> specSpecPharo8 [

	<spec>
	^ SpBoxLayout newHorizontal 
		add: (
			SpBoxLayout newVertical
				add: #projectsLocationsPresenter withConstraints: [ :constraints | constraints height: self toolbarHeight ];
				add: #projectsListPresenter);
		add:
			(SpPanedLayout newVertical
				position: 45 percent;
				add: (SpBoxLayout newHorizontal
					add: #versionsListPresenter withConstraints: [ :constraints | constraints width: 150 ];
					add: #previewPresenter;
					yourself);
				add: (SpBoxLayout newVertical
					add: #metaInfoPresenter;
					add: #toolbar withConstraints: [ :constraints | constraints height: self toolbarHeight ];
					yourself))
]

{ #category : #specs }
CMSpOpenProjectPresenter class >> title [
	^ 'CORMAS - Open project'
]

{ #category : #initialization }
CMSpOpenProjectPresenter >> connectPresenters [ 
	" Private - See superimplementor's comment "

	projectsListPresenter
		transmitTo: versionsListPresenter
		transform: [ : aCormasObject | self versionsFor: aCormasObject ]
		postTransmission: [ :destination | destination ifNotNil: [ destination selectIndex: 1 ] ];
		
		transmitTo: previewPresenter
		transform: [ : aCormasObject | self demoImageFor: aCormasObject ].
		"postTransmission: [ :destination | self halt. destination adapter buildWidget ]"

	versionsListPresenter 
		whenSelectionChangedDo: [ :aSelection | self metaInfoFor: aSelection ].

]

{ #category : #private }
CMSpOpenProjectPresenter >> cormasLocations [
	" Private - Answer a <Dictionary> of CORMAS project opening locations along with a <Closure> specifying the action to retrieve the projects for each location "

	^ OrderedDictionary newFromPairs: { 
		'Demos'	 		. [ self projectsDemos ] .
		'In-image' 		. [ self projectsInImage ].
		'User models'	. [ self projectsBrowse ]
		}
]

{ #category : #accessing }
CMSpOpenProjectPresenter >> cormasProjects [
	^ cormasProjects
		ifNil: [ cormasProjects := self defaultCormasProjects ]
]

{ #category : #accessing }
CMSpOpenProjectPresenter >> cormasProjects: anObject [
	cormasProjects := anObject
]

{ #category : #defaults }
CMSpOpenProjectPresenter >> defaultCormasProjects [
	" Answer a <Collection> of <CMProjectModel> "
	
	^ #()
]

{ #category : #private }
CMSpOpenProjectPresenter >> defaultSpecSelector [

	^ SystemVersion current major = 8
		ifTrue: [ #specSpecPharo8 ]
		ifFalse: [ #defaultSpec ]
]

{ #category : #private }
CMSpOpenProjectPresenter >> demoImageFor: aCormasObject [
	" Answer a <Morph> of representing a demo image or animation for aCormasObject "

	^ aCormasObject 
		ifNotNil: [ : cmObj | cmObj cormasDemoImage ]
		ifNil: [ CMResourceOpener cormasDemoImage ]
]

{ #category : #accessing }
CMSpOpenProjectPresenter >> initialExtent [
	"Answer the initial extent for the receiver."
	
	^ (800 @ 700) scaledByDisplayScaleFactor
]

{ #category : #initialization }
CMSpOpenProjectPresenter >> initializeButtonBar [

	self toolbar
     add: (self newButton
                    label: self translator tCancel;
                    icon: (self iconNamed: #smallCancel);
                    action: [ self delete ] );
		add: (self newButton
                    label: self translator tHelp;
                    icon: (self iconNamed: #help);
                    action: [ self openProjectHelp ]);
		add: (self newButton
                    label: self translator tOk;
                    icon: (self iconNamed: #smallOk);
                    action: [ self openSelectedProject ] )

]

{ #category : #initialization }
CMSpOpenProjectPresenter >> initializeLocationsPresenter [
	" Private - Configure the receiver's locations where CORMAS projects could be found "

	projectsLocationsPresenter  
		items: self cormasLocations keys;
		transmitTo: projectsListPresenter
		transform: [ : locationId | self projectsFor: (self locationIdentifierFor: locationId) ];
		"postTransmission: [ :destination :origin | destination selectIndex: 1 ];"
		selectIndex: 1.
]

{ #category : #initialization }
CMSpOpenProjectPresenter >> initializePresenters [

	projectsLocationsPresenter := self newDropList.
	projectsListPresenter := self newList.
	versionsListPresenter := self newList.
	metaInfoPresenter := self instantiate: CMSpOpenProjectNotebookPresenter.
	previewPresenter := self newMorph.
	toolbar := self newButtonBar.
	self setFocus.
	
	self 
		initializeLocationsPresenter;
		initializeProjectsPresenter;
		initializeVersionsPresenter;
		initializeButtonBar
	


]

{ #category : #initialization }
CMSpOpenProjectPresenter >> initializeProjectsPresenter [
	" #enableItemSubstringFilter will be removed: Do a component  with a list and a text field, you subscribe to text change, you apply filter and update list items. So you do not add behaviour to a SpListPresenter, you create a presenter (say “ListWithFilterPresenter”) that combines two low level presenters, in pure Spec spirit "

	projectsListPresenter 
		"enableItemSubstringFilter;"
		headerTitle: 'Projects';
		activateOnDoubleClick;
		display: [ : fileRef | fileRef asCormasProjectName ];
		sortingBlock: [ :a :b | a asCormasProjectName < b asCormasProjectName ];
		whenActivatedDo: [ self openSelectedProject ].
]

{ #category : #initialization }
CMSpOpenProjectPresenter >> initializeVersionsPresenter [
	" #enableItemSubstringFilter will be removed: Do a component  with a list and a text field, you subscribe to text change, you apply filter and update list items. So you do not add behaviour to a SpListPresenter, you create a presenter (say “ListWithFilterPresenter”) that combines two low level presenters, in pure Spec spirit "
	
	versionsListPresenter
		"enableItemSubstringFilter;"
		headerTitle: 'Versions';
		display: [ :item | item versionString ].


]

{ #category : #private }
CMSpOpenProjectPresenter >> locationIdentifierFor: locId [
	" Temporary patch for backward compatibility with Pharo 8. To be removed "
	
	^ locId isString ifTrue: [ locId ] ifFalse: [ locId model ]
]

{ #category : #private }
CMSpOpenProjectPresenter >> locationSelectorFor: locationId [

	^ self cormasLocations at: locationId
]

{ #category : #callbacks }
CMSpOpenProjectPresenter >> metaInfoFor: aSelection [

	aSelection
		ifNotNil: [ : spSel | metaInfoPresenter selectedModel: spSel selectedItem ]

]

{ #category : #accessing }
CMSpOpenProjectPresenter >> metaInfoPresenter [
	^ metaInfoPresenter
]

{ #category : #callbacks }
CMSpOpenProjectPresenter >> openSelectedProject [
	" Private - Callback for the Ok to open button in the Open Project Dialog and close the receiver  "

	self projectManager 
		closeProject;
		openProject: self selectedProject.
	self delete.

]

{ #category : #accessing }
CMSpOpenProjectPresenter >> previewPresenter [
	^ previewPresenter
]

{ #category : #callbacks }
CMSpOpenProjectPresenter >> projectsBrowse [
	
	^ CMResourceLocator cormasUserProjects
]

{ #category : #callbacks }
CMSpOpenProjectPresenter >> projectsDemos [
	" Answer a <Collection> of <FileReference> in the default built-in location "
	
	^ CMResourceLocator demosPath allChildrenMatching: '*.' , CMProjectModel projectFileExtension
]

{ #category : #private }
CMSpOpenProjectPresenter >> projectsFor: locationId [

	^ (self locationSelectorFor: locationId) value.
]

{ #category : #callbacks }
CMSpOpenProjectPresenter >> projectsInImage [
	" Answer a <Collection> of <CMProjectModel> for the models in the current image "

	^ CMAbstractModel subclasses collect: [ : cmModelClass |
		CMProjectModel forModel: cmModelClass new ]
]

{ #category : #accessing }
CMSpOpenProjectPresenter >> projectsListPresenter [
	^ projectsListPresenter
]

{ #category : #accessing }
CMSpOpenProjectPresenter >> projectsLocationsPresenter [
	^ projectsLocationsPresenter
]

{ #category : #accessing }
CMSpOpenProjectPresenter >> selectedProject [
	" Answer a <FileReference> of the currently selected project in the receiver "
	
	^ self projectsListPresenter selection selectedItem.
]

{ #category : #private }
CMSpOpenProjectPresenter >> setFocus [

	self focusOrder
		add: projectsListPresenter;
		add: versionsListPresenter;
		add: metaInfoPresenter
]

{ #category : #accessing }
CMSpOpenProjectPresenter >> toolbar [
	^ toolbar
]

{ #category : #private }
CMSpOpenProjectPresenter >> versionsFor: aCormasObject [
	" Answer a <Collection> of versions for aCormasObject "

	^ aCormasObject 
		ifNotNil: [ : cmObj | cmObj definedCormasVersions ]
		ifNil: [ OrderedCollection new ]
]

{ #category : #accessing }
CMSpOpenProjectPresenter >> versionsListPresenter [
	^ versionsListPresenter
]
