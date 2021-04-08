function LoadExternalTriangularPolygonMesh_ply(fileName)
	global surfTriMeshStruct_;
	surfTriMeshStruct_ = MeshStruct();

	fid = fopen(fileName, 'r');
	tmp = fscanf(fid, '%s', 1);
	tmp = fscanf(fid, '%s %s %s', 3); 
	tmp = fscanf(fid, '%s %s', 2);
	surfTriMeshStruct_.numNodes = fscanf(fid, '%d', 1);
	tmp = fscanf(fid, '%s %s %s', 3); 
	tmp = fscanf(fid, '%s %s %s', 3); 
	tmp = fscanf(fid, '%s %s %s', 3);
	tmp = fscanf(fid, '%s %s', 2);
	surfTriMeshStruct_.numElements = fscanf(fid, '%d', 1);
	tmp = fscanf(fid, '%s %s %s %s %s', 5);
	tmp = fscanf(fid, '%s', 1);
	surfTriMeshStruct_.nodeCoords = fscanf(fid,'%f %f %f',[3,surfTriMeshStruct_.numNodes])'; 
	surfTriMeshStruct_.eNodMat = fscanf(fid,'%d %d %d %d',[4,surfTriMeshStruct_.numElements]); 
	surfTriMeshStruct_.eNodMat(1,:) = []; 
	surfTriMeshStruct_.eNodMat = surfTriMeshStruct_.eNodMat' + 1;
	fclose(fid);
end