function val = MeshStruct()
	val = struct(...
		'resX',							0,	...
		'resY',							0,	...
		'resZ',							0,	...
		'spanWidth',					0,	...
		'eleSize',						[],	...
		'numElements',					0,	...		
		'numNodes',						0,	...
		'numDOFs',						0,	...
		'nodeCoords',					0,	...
		'eNodMat',						0,	...
		'eDofMat',						0,	...
		'freeDOFs',						0,	...
		'fixedDOFs',					0,	...
		'Ke',							0,	...
		'uniqueElements',				[],	...
		'universalElements',			[],	...
		'Ks',							[],	...
		'storingState',					0,	...
		'diagK',						0,	...
		'eleMapBack',			[],	...
		'eleMapForward',		[],	...
		'nodMapBack',				[],	...
		'nodMapForward',			[],	...
		'solidNodeMapCoarser2Finer',	[], ...
		'intermediateNumNodes',			0,	...
		'nodesOnBoundary',				[],	...
		'elementsOnBoundary',			[],	...
		'elementUpwardMap',				[],	...
		'multiGridOperatorRI',			[],	...
		'transferMat',					[],	...
		'transferMatCoeffi',			[]	...
	);
end