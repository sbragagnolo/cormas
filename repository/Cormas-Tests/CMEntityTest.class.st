"
A CormasEntityTest is a test class for testing the behavior of CormasEntity
"
Class {
	#name : #CMEntityTest,
	#superclass : #TestCase,
	#category : #'Cormas-Tests-Model'
}

{ #category : #tests }
CMEntityTest >> testCollector [

	| model |
	model := (CMMockModel initialize; new)
		activeInit: #initRandom;
		createGridLines: 3
			columns: 3
			neighbourhood: 8
			closed: true;
		initSimulation;
		yourself.
	self assert: (model collector isKindOf: CMCollector).

]

{ #category : #tests }
CMEntityTest >> testColorOfNumber [
	self assert: (CMEntity colorOfNumber: 65) equals: Color purple
]

{ #category : #tests }
CMEntityTest >> testCormasEntityIsAbstract [
	self assert: CMEntity isAbstract
]

{ #category : #tests }
CMEntityTest >> testCormasModel [
	| model |
	model := (CMMockModel newWithActiveInit: #initRandom)
		initSimulation;
		createGridLines: 3
			columns: 3
			neighbourhood: 4
			closed: true;
		yourself.
	self assert: model centralCell cormasModel identicalTo: model.
	model
		createN: 5
		randomlyLocatedAloneEntities: CMMockAgentLocation.
	model theAgents do: [ :agent | self assert: agent cormasModel identicalTo: model ]
]

{ #category : #tests }
CMEntityTest >> testEntityName [
	self assert: CMMockCell entityName equals: 'Cell'.
	self assert: CMMockAgentLocation entityName equals: 'AgentLocation'
]

{ #category : #tests }
CMEntityTest >> testModelClass [
	self
		assert: CMMockCell modelClass
		identicalTo: CMMockModel
]
