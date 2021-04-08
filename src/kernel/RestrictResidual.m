function rCoaser = RestrictResidual(rFiner,ii)
	global meshHierarchy_;
	rFiner = reshape(rFiner,3,meshHierarchy_(ii-1).numNodes)';
	rCoaser = zeros(meshHierarchy_(ii).numNodes,3);
	rFiner1 = zeros(meshHierarchy_(ii).intermediateNumNodes,3);
	rFiner1(meshHierarchy_(ii).solidNodeMapCoarser2Finer,:) = rFiner;
	rFiner1 = rFiner1./meshHierarchy_(ii).transferMatCoeffi;
	for jj=1:3
		tmp = rFiner1(:,jj);
		tmp = tmp(meshHierarchy_(ii).transferMat);
		tmp = tmp' * meshHierarchy_(ii).multiGridOperatorRI;
		for kk=1:8
			tmp1 = meshHierarchy_(ii).eNodMat(:,kk);
			rCoaser(tmp1,jj) = rCoaser(tmp1,jj) + tmp(:,kk);				
		end
	end
	rCoaser = reshape(rCoaser', 3*meshHierarchy_(ii).numNodes, 1);	
end