function [nx, ny, nz, formatedTriMesh] = AdaptData4Voxelize(maxRes)
	global surfTriMeshStruct_;
	global domainLowerBound_;
	global domainUpperBound_;	
	%identify the outer box
	minX = min(surfTriMeshStruct_.nodeCoords(:,1)); 
	minY = min(surfTriMeshStruct_.nodeCoords(:,2)); 
	minZ = min(surfTriMeshStruct_.nodeCoords(:,3));
	maxX = max(surfTriMeshStruct_.nodeCoords(:,1)); 
	maxY = max(surfTriMeshStruct_.nodeCoords(:,2)); 
	maxZ = max(surfTriMeshStruct_.nodeCoords(:,3));	
	
	domainLowerBound_ = [minX minY minZ];
	domainUpperBound_ = [maxX maxY maxZ];
	maxDimensions = domainUpperBound_ - domainLowerBound_;
	dimensionResolutions = round(maxRes*(maxDimensions/max(maxDimensions)));
	nx = dimensionResolutions(1);
	ny = dimensionResolutions(2);
	nz = dimensionResolutions(3);
	
	%%re-organize the coord list into Nx3x3 array - The vertex coordinates for each facet, with:
	%%1 row for each facet
	%%3 columns for the x,y,z coordinates
	%%3 pages for the three vertices			
	formatedTriMesh = zeros(surfTriMeshStruct_.numElements,3,3);
	formatedTriMesh(:,:,1) = surfTriMeshStruct_.nodeCoords(surfTriMeshStruct_.eNodMat(:,1),:);
	formatedTriMesh(:,:,2) = surfTriMeshStruct_.nodeCoords(surfTriMeshStruct_.eNodMat(:,2),:);
	formatedTriMesh(:,:,3) = surfTriMeshStruct_.nodeCoords(surfTriMeshStruct_.eNodMat(:,3),:);		
end