function ExportDataset_3DTSV()
	global meshHierarchy_;
	global boundingBox_;
	global fixingCond_; global loadingCond_;
	global cartesianStressField_;

	if isempty(cartesianStressField_)
		warning('No Cartesian Stress Available!'); return;
	end
	
	fileName = strcat('../data/dataset_TSV.vtk');
	fid = fopen(fileName, 'w');	
	%%write in economic Cartesian mesh style
	%%2.1 file header (ignore 'volume mesh' for 2D)
	fprintf(fid, '%s %s %s %s', '# vtk DataFile Version');
	fprintf(fid, '%.1f\n', 3.0);
	fprintf(fid, '%s %s', 'Volume mesh'); fprintf(fid, '\n');
	fprintf(fid, '%s \n', 'ASCII');
	fprintf(fid, '%s %s', 'DATASET CARTESIAN_GRID'); fprintf(fid, '\n');
	fprintf(fid, '%s', 'Resolution:');		
	%%2.2 mesh description
	fprintf(fid, ' %d %d %d\n', [meshHierarchy_(1).resX meshHierarchy_(1).resY meshHierarchy_(1).resZ]);
	fprintf(fid, '%s', 'LowerBound:');
	fprintf(fid, ' %.6f %.6f %.6f\n', boundingBox_(1,:));
	fprintf(fid, '%s', 'UpperBound:');
	fprintf(fid, ' %.6f %.6f %.6f\n', boundingBox_(2,:));	
	fprintf(fid, '%s', 'ELEMENTS');
	fprintf(fid, ' %d', meshHierarchy_(1).numElements);
	fprintf(fid, ' %s \n', 'int');	
	fprintf(fid, '%d\n', meshHierarchy_(1).eleMapBack-1);
	%%2.2 Cartesian Stress 
	fprintf(fid, '%s %s %s %s ', 'Number of Stress Fields:');
	fprintf(fid, '%d\n', 1);
	fprintf(fid, '%s %s ', 'Node Forces:'); 
	fprintf(fid, '%d\n', size(loadingCond_,1));
	if ~isempty(loadingCond_)
		fprintf(fid, '%d %.6f %.6f %.6f\n', [double(meshHierarchy_(1).nodMapBack(loadingCond_(:,1)))-1 loadingCond_(:,2:end)]');
	end
	fprintf(fid, '%s %s ', 'Fixed Nodes:'); fprintf(fid, '%d\n', length(fixingCond_));
	if ~isempty(fixingCond_)
		fprintf(fid, '%d\n', meshHierarchy_(1).nodMapBack(fixingCond_)-1);
	end
	fprintf(fid, '%s %s ', 'Cartesian Stress:'); fprintf(fid, '%d\n', meshHierarchy_(1).numNodes);
	fprintf(fid, '%.6e %.6e %.6e %.6e %.6e %.6e\n', cartesianStressField_');
	fclose(fid);
end