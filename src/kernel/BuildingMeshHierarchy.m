function BuildingMeshHierarchy()
	global meshHierarchy_;
	global numLevels_;
	global eNodMatTemp_;
	global coarsestResolutionControl_;
	
	%%0. global ordering of nodes on each levels
	nodeVolume = 1:(int32(meshHierarchy_(1).resX)+1)*(int32(meshHierarchy_(1).resY)+1)*(int32(meshHierarchy_(1).resZ)+1);
	nodeVolume = reshape(nodeVolume', meshHierarchy_(1).resY+1, meshHierarchy_(1).resX+1, meshHierarchy_(1).resZ+1);

	for ii=2:numLevels_
		%%1. adjust voxel resolution
		spanWidth = 2;		
		nx = meshHierarchy_(ii-1).resX/spanWidth;
		ny = meshHierarchy_(ii-1).resY/spanWidth;
		nz = meshHierarchy_(ii-1).resZ/spanWidth;
		
		%%2. initialize mesh
		meshHierarchy_(ii) = MeshStruct();
		meshHierarchy_(ii).resX = nx;
		meshHierarchy_(ii).resY = ny;
		meshHierarchy_(ii).resZ = nz;
		meshHierarchy_(ii).eleSize = meshHierarchy_(ii-1).eleSize*spanWidth;
		meshHierarchy_(ii).spanWidth = spanWidth;
		
		%%3. identify solid&void elements
		%%3.1 capture raw info.
		iEleVolume = reshape(meshHierarchy_(ii-1).eleMapForward, spanWidth*ny, spanWidth*nx, spanWidth*nz);
		iEleVolumeTemp = reshape((1:int32(spanWidth^3*nx*ny*nz))', spanWidth*ny, spanWidth*nx, spanWidth*nz);
		iFineNodVolumeTemp = reshape((1:int32((spanWidth*nx+1)*(spanWidth*ny+1)* ...
			(spanWidth*nz+1)))', spanWidth*ny+1, spanWidth*nx+1, spanWidth*nz+1);
	
		elementUpwardMap = zeros(nx*ny*nz,spanWidth^3,'int32');
		elementUpwardMapTemp = zeros(nx*ny*nz,spanWidth^3,'int32');
		transferMatTemp = zeros((spanWidth+1)^3,nx*ny*nz,'int32');	
		for jj=1:nz
			iFineEleGroup = iEleVolume(:,:,spanWidth*(jj-1)+1:spanWidth*(jj-1)+spanWidth);
			iFineEleGroupTemp = iEleVolumeTemp(:,:,spanWidth*(jj-1)+1:spanWidth*(jj-1)+spanWidth);
			iFineNodGroupTemp = iFineNodVolumeTemp(:,:,spanWidth*(jj-1)+1:spanWidth*jj+1);
			for kk=1:nx
				iFineEleSubGroup = iFineEleGroup(:,spanWidth*(kk-1)+1:spanWidth*(kk-1)+spanWidth,:);
				iFineEleSubGroupTemp = iFineEleGroupTemp(:,spanWidth*(kk-1)+1:spanWidth*(kk-1)+spanWidth,:);
				iFineNodSubGroupTemp = iFineNodGroupTemp(:,spanWidth*(kk-1)+1:spanWidth*kk+1,:);
				for gg=1:ny
					iFineEles = iFineEleSubGroup(spanWidth*(gg-1)+1:spanWidth*(gg-1)+spanWidth,:,:);
					iFineEles = reshape(iFineEles, spanWidth^3, 1)';
					iFineElesTemp = iFineEleSubGroupTemp(spanWidth*(gg-1)+1:spanWidth*(gg-1)+spanWidth,:,:);
					iFineElesTemp = reshape(iFineElesTemp, spanWidth^3, 1)';
					iFineNodsTemp = iFineNodSubGroupTemp(spanWidth*(gg-1)+1:spanWidth*gg+1,:,:);
					iFineNodsTemp = reshape(iFineNodsTemp, (spanWidth+1)^3, 1)';
					eleIndex = (jj-1)*ny*nx + (kk-1)*ny + gg;
					elementUpwardMap(eleIndex,:) = iFineEles;	
					elementUpwardMapTemp(eleIndex,:) = iFineElesTemp;
					transferMatTemp(:,eleIndex) = iFineNodsTemp;						
				end
			end
		end
		
		%%3.2 building the mapping relation for following tri-linear interpolation					
		%					 _______						 _______ _______
		%					|		|						|		|		|
		%			void	|solid	|						|void	|solid	|
		%					|		|						|		|		|
		%			 _______|_______|						|_______|_______|		
		%			|		|		|		<----->			|		|		|
		%			|solid	|solid	|						|solid	|solid	|	
		%			|		|		|						|		|		|
		%			|_______|_______|						|_______|_______|
		% elementsIncVoidLastLevelGlobalOrdering	elementsLastLevelGlobalOrdering
		unemptyElements = find(sum(elementUpwardMap,2)>0);
		elementUpwardMapTemp = elementUpwardMapTemp(unemptyElements,:);
		elementsIncVoidLastLevelGlobalOrdering = reshape(elementUpwardMapTemp, numel(elementUpwardMapTemp), 1);
		nodesIncVoidLastLevelGlobalOrdering = unique(eNodMatTemp_(elementsIncVoidLastLevelGlobalOrdering,:));
		meshHierarchy_(ii).intermediateNumNodes = length(nodesIncVoidLastLevelGlobalOrdering);
		transferMatTemp = transferMatTemp(:,unemptyElements);
		temp = zeros((spanWidth*nx+1)*(spanWidth*ny+1)*(spanWidth*nz+1),1,'int32');		
		temp(nodesIncVoidLastLevelGlobalOrdering) = (1:meshHierarchy_(ii).intermediateNumNodes)';
		meshHierarchy_(ii).transferMat = temp(transferMatTemp);
		meshHierarchy_(ii).transferMatCoeffi = zeros(meshHierarchy_(ii).intermediateNumNodes,1);
		for kk=1:(spanWidth+1)^3
			solidNodesLastLevel = meshHierarchy_(ii).transferMat(kk,:);
			meshHierarchy_(ii).transferMatCoeffi(solidNodesLastLevel,1) = ...
				meshHierarchy_(ii).transferMatCoeffi(solidNodesLastLevel,1) + 1;
		end
		elementsLastLevelGlobalOrdering = meshHierarchy_(ii-1).eleMapBack;
		nodesLastLevelGlobalOrdering = unique(eNodMatTemp_(elementsLastLevelGlobalOrdering,:));
		[~,meshHierarchy_(ii).solidNodeMapCoarser2Finer] = ...
			intersect(nodesIncVoidLastLevelGlobalOrdering, nodesLastLevelGlobalOrdering);
		meshHierarchy_(ii).solidNodeMapCoarser2Finer = int32(meshHierarchy_(ii).solidNodeMapCoarser2Finer);
	
		%%3.3 initialize the solid elements 
		meshHierarchy_(ii).eleMapForward = zeros(nx*ny*nz,1,'int32');
		meshHierarchy_(ii).eleMapBack = int32(unemptyElements);
		meshHierarchy_(ii).numElements = length(unemptyElements);
		meshHierarchy_(ii).eleMapForward(unemptyElements) = ...
			(1:meshHierarchy_(ii).numElements)';
		elementUpwardMap = elementUpwardMap(unemptyElements,:);	
		meshHierarchy_(ii).elementUpwardMap = elementUpwardMap; clear elementUpwardMap
		
		%%4. discretize
		nodenrs = reshape(1:int32((nx+1)*(ny+1)*(nz+1)), 1+meshHierarchy_(ii).resY, ...
			1+meshHierarchy_(ii).resX, 1+meshHierarchy_(ii).resZ);
		eNodVec = reshape(nodenrs(1:end-1,1:end-1,1:end-1)+1,nx*ny*nz, 1);
		eNodMat = repmat(eNodVec(meshHierarchy_(ii).eleMapBack),1,8);
		eNodMatTemp_ = repmat(eNodVec,1,8);
		tmp = [0 ny+[1 0] -1 (ny+1)*(nx+1)+[0 ny+[1 0] -1]]; tmp = int32(tmp);
		for jj=1:8
			eNodMat(:,jj) = eNodMat(:,jj) + repmat(tmp(jj), meshHierarchy_(ii).numElements,1);
			eNodMatTemp_(:,jj) = eNodMatTemp_(:,jj) + repmat(tmp(jj), nx*ny*nz,1);
		end
		meshHierarchy_(ii).nodMapBack = unique(eNodMat);
		meshHierarchy_(ii).numNodes = length(meshHierarchy_(ii).nodMapBack);
		meshHierarchy_(ii).numDOFs = meshHierarchy_(ii).numNodes*3;
		meshHierarchy_(ii).nodMapForward = zeros((nx+1)*(ny+1)*(nz+1),1,'int32');
		meshHierarchy_(ii).nodMapForward(meshHierarchy_(ii).nodMapBack) = (1:meshHierarchy_(ii).numNodes)';		
		for jj=1:8
			eNodMat(:,jj) = meshHierarchy_(ii).nodMapForward(eNodMat(:,jj));
		end
		kk = ii-1;		
		tmp = nodeVolume(1:2^kk:meshHierarchy_(1).resY+1, 1:2^kk:meshHierarchy_(1).resX+1, 1:2^kk:meshHierarchy_(1).resZ+1);
		tmp = reshape(tmp,numel(tmp),1);
		meshHierarchy_(ii).nodMapBack = tmp(meshHierarchy_(ii).nodMapBack);
	
		%%5. initialize multi-grid Restriction&Interpolation operator
		meshHierarchy_(ii).multiGridOperatorRI = Operator4MultiGridRestrictionAndInterpolation('inNODE', spanWidth);
	
		%%6. identify boundary info.
		numElesAroundNode = zeros(meshHierarchy_(ii).numNodes,1,'int32');
		for jj=1:meshHierarchy_(ii).numElements
			iNodes = eNodMat(jj,:);
			numElesAroundNode(iNodes,:) = numElesAroundNode(iNodes) + 1;		
		end
		meshHierarchy_(ii).nodesOnBoundary = int32(find(numElesAroundNode<8));
		allNodes = zeros(meshHierarchy_(ii).numNodes,1,'int32');
		allNodes(meshHierarchy_(ii).nodesOnBoundary) = 1;	
		tmp = zeros(meshHierarchy_(ii).numElements,1,'int32');
		for jj=1:8
			tmp = tmp + allNodes(eNodMat(:,jj));
		end
		meshHierarchy_(ii).elementsOnBoundary = int32(find(tmp>0));
		meshHierarchy_(ii).eNodMat = eNodMat; clear eNodMat;
		if meshHierarchy_(ii).numElements<coarsestResolutionControl_
			numLevels_ = length(meshHierarchy_); break;
		end
	end	
	clear -global eNodMatTemp_
% 	if numLevels_>2
% 		for ii=numLevels_:-1:1
% 			if meshHierarchy_(ii).numElements>coarsestResolutionControl_
% 				climactericRes = ii+1; break;
% 			end
% 		end
% 		climactericRes
% 		meshHierarchy_(climactericRes:end) = [];
% 		numLevels_ = length(meshHierarchy_);
% 	end
end