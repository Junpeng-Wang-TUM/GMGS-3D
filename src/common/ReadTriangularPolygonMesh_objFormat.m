function ReadTriangularPolygonMesh_objFormat(fileName)
	global surfTriMeshStruct_;
	surfTriMeshStruct_ = MeshStruct();
	nodeCoordsTri = []; eNodMatTri = [];
	fid = fopen(fileName, 'r');
	while 1
		tline = fgetl(fid);
		if ~ischar(tline),   break,   end  % exit at end of file 
		ln = sscanf(tline,'%s',1); % line type 
		switch ln
			case 'v' % graph vertexs
				nodeCoordsTri(end+1,1:3) = sscanf(tline(2:end), '%e')';
			case 'f'
				eNodMatTri(end+1,1:3) = sscanf(tline(2:end), '%d')';
		end
	end
	fclose(fid);
    nodeCoordsTri = nodeCoordsTri(:,[1 3 2]);
    nodeCoordsTri(:,2) = -nodeCoordsTri(:,2);
	surfTriMeshStruct_.numNodes = size(nodeCoordsTri,1);
	surfTriMeshStruct_.nodeCoords = nodeCoordsTri;
	surfTriMeshStruct_.numElements = size(eNodMatTri,1);
	surfTriMeshStruct_.eNodMat = eNodMatTri;
end
