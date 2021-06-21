function WrapVoxelFEAmodel()
	global domainType_;
	global meshHierarchy_;
	global fixingCond_; global loadingCond_;
	global outPath_;
	
	fileName = '../data/wrappedVoxelFEAmodel.txt';
	fid = fopen(fileName, 'w');	
	fprintf(fid, '%s %s %s', 'domain type: 3D'); fprintf(fid, '\n');
	fprintf(fid, '%s ', 'resolution:'); 
	fprintf(fid, '%d %d %d\n', [meshHierarchy_(1).resX meshHierarchy_(1).resY meshHierarchy_(1).resZ]);
	fprintf(fid, '%s %s ', 'valid elements:');
	fprintf(fid, '%d\n', meshHierarchy_(1).numElements);
	fprintf(fid, '%d\n', meshHierarchy_(1).eleMapBack');
	fprintf(fid, '%s %s ', 'fixed position:');
	fprintf(fid, '%d\n', length(fixingCond_));		
	if ~isempty(fixingCond_)
		fprintf(fid, '%d\n', meshHierarchy_(1).nodMapBack(fixingCond_));
	end
	fprintf(fid, '%s %s ', 'loading condition:');
	fprintf(fid, '%d\n', size(loadingCond_,1));
	if ~isempty(loadingCond_)
		fprintf(fid, '%d %.6f %.6f %.6f\n', [double(meshHierarchy_(1).nodMapBack(loadingCond_(:,1))) loadingCond_(:,2:end)]');
	end		
	fclose(fid);
end