Class {
	#name : #CMAbstractModelTest,
	#superclass : #CMTestObject,
	#category : #'Cormas-Tests-Model'
}

{ #category : #running }
CMAbstractModelTest >> cleanGeneratedMethods [

	(self projectModel cormasModelClass respondsTo: #creationDate)
		ifTrue: [ self projectModel cormasModelClass class removeSelector: #creationDate ].
]

{ #category : #test }
CMAbstractModelTest >> cormasModelNamesForTests [

	^ 'DemoAquifer
SIS
DemoAggregates
Conway
DemoArcsNodes
DemoAquiferPollution
WolfSheepPredation
Diffuse
FireModel
DemoWayTo
DemoAquifer
ECEC' lines
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> newProjectManager [

	^ CMProjectManager new 
		currentProject: (CMProjectModel basicNew
				initializeForModel: model named: self sampleModelNameWithoutPrefix;
				yourself);
		yourself
]

{ #category : #test }
CMAbstractModelTest >> newValidEntityNamed: entityName [

	CMSpatialEntityAggregate subclass: (entityName asValidCormasClassName: self sampleModelNameWithoutPrefix)
]

{ #category : #test }
CMAbstractModelTest >> sampleModelName [

	^ 'CMXXXModel'
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> sampleModelNameWithoutPrefix [

	^ 'SampleModel'
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> setUp [ 

	super setUp.
	model := self newTestModel.
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testCentralCell [
	| m |
	m := (CMMockModel	newWithActiveInit: #initRandom)
		initSimulation;
		createGridLines: 3
			columns: 3
			neighbourhood: 4
			closed: true;
		yourself.
	self
		assert: m centralCell
		identicalTo: (m selectCellsOfColumn: 2) second
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testClassNameFromEntityName [
	self
		assert: (CMMockCell modelClass classNameFromEntityName: CMMockCell entityName)
		equals: CMMockCell name
]

{ #category : #tests }
CMAbstractModelTest >> testCreateGridXYNeighborHoodClosed [

	self assert: model allTheEntities size equals: 200.
	self assert: (model selectCellsOfColumn: 1) size equals: 20.
	self assert: (model selectCellsOfLine: 1) size equals: 10
]

{ #category : #tests }
CMAbstractModelTest >> testDominance [
	| m |
	m := (CMMockModel	newWithActiveInit: #initRandom)
		initSimulation;
		createGridLines: 100
			columns: 100
			neighbourhood: 4
			closed: true;
		yourself.
	self assert: (m dominance: #state) < 1.0.

]

{ #category : #tests }
CMAbstractModelTest >> testDominance1 [
	| m |
	m := (CMMockModel	newWithActiveInit: #initRandom)
		initSimulation;
		createGridLines: 100
			columns: 100
			neighbourhood: 4
			closed: true;
		yourself.
	self assert: (m dominance: #state) < 1.0
]

{ #category : #test }
CMAbstractModelTest >> testFriendlyName [

	self deny: (model friendlyName beginsWith: 'CM')
]

{ #category : #test }
CMAbstractModelTest >> testHasActiveInit [

	self assert: model hasActiveInit.
	model activeInit: nil.
	self deny: model hasActiveInit.
	
]

{ #category : #test }
CMAbstractModelTest >> testHasActiveProbes [

	self deny: model hasActiveProbes.
	model setActiveProbes: #(#Global).
	self assert: model hasActiveProbes.
	model setActiveProbes: Array empty.
]

{ #category : #test }
CMAbstractModelTest >> testHasControlInit [

	self deny: model hasControlInit.
	model activeControl: #step:.
	self assert: model hasControlInit.

	
]

{ #category : #test }
CMAbstractModelTest >> testInitSimulation [

	model := (CMMockModel	newWithActiveInit: #initRandom)
		activeControl: #step:;
		yourself.
	self deny: model initStatus.
	model initSimulation.
	self assert: model initStatus.
]

{ #category : #test }
CMAbstractModelTest >> testInitStatus [

	self assert: model initStatus.
	model initStatus: false.
	self deny: model initStatus.
	
]

{ #category : #test }
CMAbstractModelTest >> testIsInitialized [

	model := (CMMockModel
		initialize;
		new)
		activeInit: #initAlive;
		activeControl: #step:.
	self deny: model isInitialized.
	model initSimulation.
	self assert: model isInitialized.
	model activeInit: nil.
	self deny: model isInitialized.
	model activeInit: #initAlive.
	model activeControl: nil.
	self deny: model isInitialized.	
	
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testLowerLeftCell [
	| m |
	m := (CMMockModel newWithActiveInit: #initRandom)
		initSimulation;
		createGridLines: 3
			columns: 3
			neighbourhood: 4
			closed: true;
		yourself.
	self
		assert: m lowerLeftCell
		identicalTo: (m selectCellsOfColumn: 1) third
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testLowerRightCell [
	| m |
	m := (CMMockModel newWithActiveInit: #initRandom)
		initSimulation;
		createGridLines: 3
			columns: 3
			neighbourhood: 4
			closed: true;
		yourself.
	self
		assert: m lowerRightCell
		identicalTo: (m selectCellsOfColumn: 3) third
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testModelPrefix [
	self assert: CMMockCell modelClass shortName equals: 'Mock'
]

{ #category : #tests }
CMAbstractModelTest >> testNbDistinctValuesOf [

	self assert: (model nbDistinctValuesOf: #state) equals: 1.
	(model selectCellsOfLine: 1) do: [ :cell | cell state: #dead ].
	self assert: (model nbDistinctValuesOf: #state) equals: 2.
	(model selectCellsOfLine: 2) first state: #theThirdState.
	self assert: (model nbDistinctValuesOf: #state) equals: 3
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testPickCell [
	| cell |

	cell := model pickCell.
	self assert: cell isSpatialEntity.
	self assert: (cell numCol between: 1 and: 10).
	self assert: (cell numLine between: 1 and: 20)
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testPickCellConstrainedBy [
	| m |
	m := (CMMockModel newWithActiveInit: #initRandom)
		initSimulation;
		createGridLines: 9
			columns: 9
			neighbourhood: 4
			closed: true;
		yourself.
	m centralCell state: #alive.
	self
		assert: (m pickCellConstrainedBy: [ :cell | cell state = #alive ]) state
		equals: #alive.
	m centralCell state: #dead.
	self
		assert: (m pickCellConstrainedBy: [ :cell | cell state = #dead ]) state
		equals: #dead
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testPickCellWithoutAny [

	model createN: 50 randomlyLocatedAloneEntities: CMMockAgentLocation.
	self assert: ((model pickCellWithoutAny: CMMockAgentLocation)
				occupantsAt: CMMockAgentLocation) isEmpty
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testPickCellsN [

	self assert: ((model pickCellsN: 5) allSatisfy: #isSpatialEntity)
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testPickEntity [

	self assert: (model pickEntity: CMMockCell) isSpatialEntity
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testPickEntityConstrainedBy [

	self
		assert:
			(model
				pickEntity: CMMockCell
				constrainedBy: [ :cell | cell numCol = 3 ]) numCol
		equals: 3.
	self
		assert:
			(model
				pickEntity: CMMockCell
				constrainedBy: [ :cell | cell numCol = 6 ]) numCol
		equals: 6.
	self
		assert:
			(model
				pickEntity: CMMockCell
				constrainedBy: [ :cell | cell numCol = 9 ]) numCol
		equals: 9
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testPickNEntities [

	self
		assert:
			((model pickN: 5 entities: CMMockCell) allSatisfy: #isSpatialEntity)
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testPickNEntitiesConstrainedBy [

	self
		assert:
			((model
				pickN: 5
				entities: CMMockCell
				constrainedBy: [ :cell | cell numCol = 5 ])
				allSatisfy: [ :cell | cell numCol = 5 ])
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testPickUnoccupiedCell [

	model createN: 50 randomlyLocatedAloneEntities: CMMockAgentLocation.
	self assert: model pickUnoccupiedCell theOccupants isEmpty
]

{ #category : #tests }
CMAbstractModelTest >> testProbes [
	self
		assert: CMMockModel probes asSet
		equals: (Set with: #numAlives with: #numDeads)
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testSelectCellsBetweenLine1Line2AndColumn1Column2 [

	| m cells |
	
	m := (CMMockModel newWithActiveInit: #initAlive)
		initSimulation;
		createGridLines: 20
			columns: 10
			neighbourhood: 4
			closed: true;
		yourself.
	cells := m
		selectCellsBetweenLine1: 13
		line2: 15
		andColumn1: 6
		column2: 8.
	self assert: cells size equals: 9.
	cells do: [ :cell | 
		self assert: (cell numCol between: 6 and: 8).
		self assert: (cell numLine between: 13 and: 15) ]
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testSelectCellsInRectangleOriginCellCornerCell [
	| m cells |
	m := (CMMockModel newWithActiveInit: #initAlive)
		initSimulation;
		createGridLines: 9
			columns: 5
			neighbourhood: 4
			closed: true;
		yourself.
	cells := m
		selectCellsInRectangleOriginCell: m upperLeftCell
		cornerCell: m centralCell.
	self assert: cells size equals: 15.
	cells do: [ :cell | 
			self assert: (cell numCol between: 1 and: 3).
			self assert: (cell numLine between: 1 and: 5) ]
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testSelectCellsOfColumn [

	self assert: model allTheEntities size equals: 200.
	1 to: 10 do: [ :column | 
		1 to: 20 do: [ :line | 
			self
				assert: ((model selectCellsOfColumn: column) at: line)
				identicalTo: ((model selectCellsOfLine: line) at: column) ] ]
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testSelectCellsOfLine [

	self assert: model allTheEntities size equals: 200.
	1 to: 20 do: [ :line | 
		| cells |
		cells := model selectCellsOfLine: line.
		self assert: cells size equals: 10.
		cells do: [ :cell | self assert: cell numLine equals: line ] ]
]

{ #category : #tests }
CMAbstractModelTest >> testShortestDistanceToCellsVerifying [
	| m |
	m := CMMockModel
		initialize;
		new.
	m initSimulation.
	(m allTheEntities: CMMockCell)
		do: [ :cell | 
			self assert: (cell shortestDistanceToCellsVerifying: [ :c | c state = #dead | (c state = #alive) ])
				equals: 1 ]
]

{ #category : #tests }
CMAbstractModelTest >> testSpacialClasses [
	self
		assert: CMMockModel spatialClasses
		equals: (Set with: CMMockCell)
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testTheAgents [
	| agents |
	model createN: 50 randomlyLocatedAloneEntities: CMMockAgentLocation.
	agents := model theAgents.
	self assert: agents size equals: 50.
	agents
		do:
			[ :agent | self assert: agent class identicalTo: CMMockAgentLocation ]
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testUpperLeftCell [
	| m |
	m := (CMMockModel newWithActiveInit: #initRandom)
		initSimulation;
		createGridLines: 3
			columns: 3
			neighbourhood: 4
			closed: true;
		yourself.
	self
		assert: m upperLeftCell
		identicalTo: (m selectCellsOfColumn: 1) first
]

{ #category : #'tests-accessing-entities' }
CMAbstractModelTest >> testUpperRightCell [
	| m |
	m := (CMMockModel newWithActiveInit: #initRandom)
		initSimulation;
		createGridLines: 3
			columns: 3
			neighbourhood: 4
			closed: true;
		yourself.
	self
		assert: m upperRightCell
		identicalTo: (m selectCellsOfColumn: 3) first
]
