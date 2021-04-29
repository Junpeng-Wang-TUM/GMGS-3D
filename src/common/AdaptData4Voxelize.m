function [nx, ny, nz, formatedTriMesh] = AdaptData4Voxelize(maxRes)
	global surfTriMeshStruct_;
	global boundingBox_;

	%identify the bounding box	
	boundingBox_ = [min(surfTriMeshStruct_.nodeCoords,[],1); max(surfTriMeshStruct_.nodeCoords,[],1)];
	maxDimensions = boundingBox_(2,:) - boundingBox_(1,:);
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