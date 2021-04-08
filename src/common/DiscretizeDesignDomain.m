function DiscretizeDesignDomain()	
	global nelx_; global nely_; global nelz_; 
	global domainLowerBound_; global domainUpperBound_;
	global voxelizedVolume_; 
	global meshHierarchy_;
	global nodeCoords_;
	global characteristicSize_;
	global coarsestResolutionControl_;
	global numNod2ElesVec_;
	global eNodMatTemp_;
	global numLevels_;
	%    z
	%    |__ x
	%   / 
	%  -y                            
	%            8--------------7      	
	%			/ |			   /|	
	%          5-------------6	|
	%          |  |          |  |
	%          |  |          |  |	
	%          |  |          |  |   
	%          |  4----------|--3  
	%     	   | /           | /
	%          1-------------2             
	%			Hexahedral element
	
	%%1. adjust voxel resolution for building Mesh Hierarchy 
	numVoxels = nelx_*nely_*nelz_;
	numLevels_ = 0;
	while numVoxels>coarsestResolutionControl_
		numLevels_ = numLevels_+1;
		numVoxels = nelx_/2^numLevels_ * nely_/2^numLevels_ * nelz_/2^numLevels_;
	end
	adjustedNelx = ceil(nelx_/2^numLevels_)*2^numLevels_;
	adjustedNely = ceil(nely_/2^numLevels_)*2^numLevels_;
	adjustedNelz = ceil(nelz_/2^numLevels_)*2^numLevels_;
	numLevels_ = numLevels_ + 1;
	if adjustedNelx>nelx_
		voxelizedVolume_(:,end+1:adjustedNelx,:) = zeros(nely_,adjustedNelx-nelx_,nelz_,'int32');
	end
	if adjustedNely>nely_
		voxelizedVolume_(end+1:adjustedNely,:,:) = zeros(adjustedNely-nely_,adjustedNelx,nelz_,'int32');
	end
	if adjustedNelz>nelz_
		voxelizedVolume_(:,:,end+1:adjustedNelz) = zeros(adjustedNely,adjustedNelx,adjustedNelz-nelz_,'int32');
	end

	%%2. initialize characteristic size
	domainLowerBound_ = [0 0 0]; 
	domainUpperBound_ = domainLowerBound_+[nelx_ nely_ nelz_];
	if ~isempty(characteristicSize_)
		domainUpperBound_ = domainLowerBound_ + (domainUpperBound_-domainLowerBound_)/ ...
			max(domainUpperBound_-domainLowerBound_) * characteristicSize_;
	end
	domainUpperBound_ = domainLowerBound_ + (domainUpperBound_-domainLowerBound_).* ...
		[adjustedNelx adjustedNely adjustedNelz]./[nelx_ nely_ nelz_];
	
	%%3. initialize the finest mesh
	meshHierarchy_ = MeshStruct();
	meshHierarchy_.resX = adjustedNelx; nx = meshHierarchy_.resX;
	meshHierarchy_.resY = adjustedNely; ny = meshHierarchy_.resY;
	meshHierarchy_.resZ = adjustedNelz; nz = meshHierarchy_.resZ;
	meshHierarchy_.eleSize = [domainUpperBound_ - domainLowerBound_] ./ [nx ny nz];

	%%4. identify solid&void elements
	meshHierarchy_.solidElementsMapVec = find(1==voxelizedVolume_);
	meshHierarchy_.solidElementsMapVec = int32(meshHierarchy_.solidElementsMapVec);
	meshHierarchy_.numElements = length(meshHierarchy_.solidElementsMapVec);
	meshHierarchy_.solidVoidElementsLabel = zeros(nx*ny*nz,1);	
	meshHierarchy_.solidVoidElementsLabel(meshHierarchy_.solidElementsMapVec) = (1:meshHierarchy_.numElements)';
	meshHierarchy_.solidVoidElementsLabel = int32(meshHierarchy_.solidVoidElementsLabel);
		
	%%5. discretize
	nodenrs = reshape(1:(nx+1)*(ny+1)*(nz+1), 1+ny, 1+nx, 1+nz); nodenrs = int32(nodenrs);
	eNodVec = reshape(nodenrs(1:end-1,1:end-1,1:end-1)+1, nx*ny*nz, 1);
	eNodMatTemp_ = repmat(eNodVec,1,8);
	eNodMat = repmat(eNodVec(meshHierarchy_.solidElementsMapVec),1,8);
	tmp = [0 ny+[1 0] -1 (ny+1)*(nx+1)+[0 ny+[1 0] -1]]; tmp = int32(tmp);
	for ii=1:8
		eNodMat(:,ii) = eNodMat(:,ii) + repmat(tmp(ii), meshHierarchy_.numElements,1);
		eNodMatTemp_(:,ii) = eNodMatTemp_(:,ii) + repmat(tmp(ii), nx*ny*nz,1);
	end
	meshHierarchy_.solidNodesMapVec = unique(eNodMat);
	meshHierarchy_.numNodes = length(meshHierarchy_.solidNodesMapVec);
	meshHierarchy_.numDOFs = meshHierarchy_.numNodes*3;
	meshHierarchy_.solidVoidNodesLabel = zeros((nx+1)*(ny+1)*(nz+1),1);
	meshHierarchy_.solidVoidNodesLabel(meshHierarchy_.solidNodesMapVec) = (1:meshHierarchy_.numNodes)';
	meshHierarchy_.solidVoidNodesLabel = int32(meshHierarchy_.solidVoidNodesLabel);
	for ii=1:8
		eNodMat(:,ii) = meshHierarchy_.solidVoidNodesLabel(eNodMat(:,ii));
	end
	nodeCoords_ = zeros((nx+1)*(ny+1)*(nz+1),3);
	[nodeCoords_(:,1) nodeCoords_(:,2) nodeCoords_(:,3)] = NodalizeDesignDomain([nx ny nz], [domainLowerBound_; domainUpperBound_]);
	
	%%6. identify boundary info.
	numNod2ElesVec_ = zeros(meshHierarchy_.numNodes,1);
	for ii=1:meshHierarchy_.numElements
		iNodes = eNodMat(ii,:);
		numNod2ElesVec_(iNodes,:) = numNod2ElesVec_(iNodes) + 1;
	end	
	meshHierarchy_.nodesOnBoundary = find(numNod2ElesVec_<8);
	meshHierarchy_.nodesOnBoundary = int32(meshHierarchy_.nodesOnBoundary);
	allNodes = zeros(meshHierarchy_.numNodes,1,'int32');
	allNodes(meshHierarchy_.nodesOnBoundary) = 1;	
	tmp = zeros(meshHierarchy_.numElements,1,'int32');
	for ii=1:8
		tmp = tmp + allNodes(eNodMat(:,ii));
	end
	meshHierarchy_.elementsOnBoundary = int32(find(tmp>0));
	
	%%7. update to mesh struct
	meshHierarchy_.eNodMat = eNodMat;
end
