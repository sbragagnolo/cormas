Class {
	#name : #CMECECForager,
	#superclass : #CMAgentLocation,
	#instVars : [
		'energy'
	],
	#classInstVars : [
		'fertilityThreshold',
		'catabolicRate',
		'harvestRate',
		'palette'
	],
	#category : #'Cormas-Model-ECEC'
}

{ #category : #'pov symbols' }
CMECECForager class >> VectorialPOV_Forager [

	^ #( 0.833354 0.833354 0.833354 0.0 0.0 0.0 1 0.6 #center #( 0 #@-
	        17 15 #@- 9 15 #@ 9 0 #@ 17  -15 #@ 9  -15 #@- 9 0 #@- 17 ) )
]

{ #category : #accessing }
CMECECForager class >> catabolicRate [

	| tmp1 |
	tmp1 := catabolicRate.
	^ tmp1 ifNil: [ catabolicRate := 2 ] ifNotNil: [ tmp1 ]
]

{ #category : #accessing }
CMECECForager class >> catabolicRate: arg1 [

	catabolicRate := arg1
]

{ #category : #'default value' }
CMECECForager class >> catabolicRate_default [

	^ 2
]

{ #category : #default }
CMECECForager class >> defaultProbes [

	^ self probes
]

{ #category : #'default value' }
CMECECForager class >> energy_default [

	^ 50
]

{ #category : #accessing }
CMECECForager class >> fertilityThreshold [

	| tmp1 |
	tmp1 := fertilityThreshold.
	^ tmp1 ifNil: [ fertilityThreshold := 100 ] ifNotNil: [ tmp1 ]
]

{ #category : #accessing }
CMECECForager class >> fertilityThreshold: arg1 [

	fertilityThreshold := arg1
]

{ #category : #'default value' }
CMECECForager class >> fertilityThreshold_default [

	^ 100
]

{ #category : #accessing }
CMECECForager class >> harvestRate [

	^ harvestRate
]

{ #category : #accessing }
CMECECForager class >> harvestRate: arg1 [

	harvestRate := arg1
]

{ #category : #'default value' }
CMECECForager class >> harvestRate_default [

	^ nil
]

{ #category : #testing }
CMECECForager class >> isAbstract [

	^ true
]

{ #category : #biology }
CMECECForager >> consumeEnergy [

	self energy: self energy - self class catabolicRate
]

{ #category : #biology }
CMECECForager >> die [

	self dead: true
]

{ #category : #biology }
CMECECForager >> eat [
	"The forager eats a quatity of biomass of its current location. The quantity depends on the harvestRate: a proportion of biomass (50% or 99% according to forager type)"
	
	| qty |
	patch ifNil: [ ^ nil ].
	qty := self patch biomass * self class harvestRate.
	self energy: self energy + qty.
	self patch biomass: self patch biomass - qty
]

{ #category : #probes }
CMECECForager >> energy [
	" Getter accessor with initial value = 50 energyPoint. "
	<probe>

	^ energy ifNil: [ energy := 50 ]
]

{ #category : #accessing }
CMECECForager >> energy: anObject [

	energy = anObject 
		ifTrue: [ ^ nil ].
	energy := anObject.
	self changed
]

{ #category : #info }
CMECECForager >> info_energy [

	^ self energy rounded printString
]

{ #category : #printing }
CMECECForager >> interestingDetails [
	" Answer a <Collection> of interesting receiver's attributes, from a modeler point of view, to display in a popup for example "

	^ super interestingDetails , { 
		'Energy: ' -> (self energy asString)
		}
]

{ #category : #testing }
CMECECForager >> isEnergyHigh [

	^ self energy >= self class fertilityThreshold
]

{ #category : #testing }
CMECECForager >> isEnergyTooLow [

	^ self energy <= 0
]

{ #category : #biology }
CMECECForager >> move [
	" The Forager examines its current location and around. From those not occupied, he chooses the one containing the plant with the highest energy. If the chosen plant would yield enough food to meet their catabolic rate (2 units), he moves there. If not, he moves instead to a randomly chosen adjacent free place (not occupied by another forager)"	

	| goodCells |
	patch ifNil: [^nil].
	goodCells := self patch neighbourhoodAndSelf select: 
		[:cell | cell biomass > self class catabolicRate and: [cell noOccupant]].
	goodCells isEmpty
		ifTrue: [self randomWalkConstrainedBy: [:c | c noOccupant]]
		ifFalse: [self moveTo: (goodCells asSortedCollection: [:c1 :c2 | c1 biomass > c2 biomass]) first].
	"self changePovPerceptionRange"
]

{ #category : #pov }
CMECECForager >> pov [

	self subclassResponsibility
]

{ #category : #pov }
CMECECForager >> povEnergy [

	self subclassResponsibility
]

{ #category : #biology }
CMECECForager >> reproduce [
	" The forager reproduces asexually, creating an offspring with the same heritable traits as itself (e.g., feeding strategy). At the same time the parent's energy is reduced by the offspring's initial energy (50).  Newborn offspring occupies the nearest free place to its parent. "
	
	| newForager freePlace |
	patch ifNil: [ ^ nil ].
	freePlace := self nearestEmptyLocationWithinRadius: 1.
	freePlace ifNil: [ ^ nil ].
	newForager := self newEntity: self class.
	self energy: self energy - newForager energy.
	newForager moveTo: freePlace
]

{ #category : #povSize }
CMECECForager >> sizeOfPOV [

	^ 2 + (self energy / self class fertilityThreshold * 20)
]

{ #category : #control }
CMECECForager >> step [

	self
		consumeEnergy;
		move;
		eat.
	self isEnergyHigh ifTrue: [ self reproduce ].
	self isEnergyTooLow ifTrue: [ self die ]
]
