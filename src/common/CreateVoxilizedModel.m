function voxelizedVolume = CreateVoxilizedModel(varargin)
	%%exp 1 --- CreateVoxilizedModel(triFaceModelFile, finestResCtrl)
	%%exp 2 --- CreateVoxilizedModel(nx, ny, nz)
	global boundingBox_;
	global nelx_;
	global nely_;
	global nelz_;
	global surfTriMeshStruct_;
	global formatedTriMesh_;
	switch nargin
		case 2
			triFaceModelFile = varargin{1};
			finestResCtrl = varargin{2};
            [~,~,dataType] = fileparts(triFaceModelFile);
			switch dataType
				case '.ply'
					ReadTriangularPolygonMesh_plyFormat(triFaceModelFile);
				case '.obj'
					ReadTriangularPolygonMesh_objFormat(triFaceModelFile);
				otherwise
					error('Wrong Input!');
			end
			[nelx_, nely_, nelz_, formatedTriMesh_] = AdaptData4Voxelize(finestResCtrl);
			voxelizedVolume = Voxelize(nelx_, nely_, nelz_, formatedTriMesh_);
			voxelizedVolume = flip(voxelizedVolume,1);
			boundingBox_ = [min(surfTriMeshStruct_.nodeCoords, [], 1); max(surfTriMeshStruct_.nodeCoords, [], 1)];
		case 3
			nelx_ = varargin{1};
			nely_ = varargin{2};
			nelz_ = varargin{3};
			voxelizedVolume = ones(nely_, nelx_, nelz_);
			boundingBox_ = [0 0 0; nelx_ nely_ nelz_];
		otherwise
			error('Wrong input for voxelization!');
	end
	voxelizedVolume = int32(voxelizedVolume);
end