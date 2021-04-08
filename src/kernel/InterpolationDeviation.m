function xFiner = InterpolationDeviation(xCoarser, ii)
	global meshHierarchy_;
	xCoarser = reshape(xCoarser,3,meshHierarchy_(ii).numNodes)';
	xFiner = zeros(meshHierarchy_(ii).intermediateNumNodes,3);
	nn = (meshHierarchy_(ii).spanWidth+1)^3;
	for jj=1:3
		tmp = xCoarser(:,jj);
		tmp = tmp(meshHierarchy_(ii).eNodMat);
		tmp1 = meshHierarchy_(ii).multiGridOperatorRI * tmp';
		for kk=1:nn
			tmp2 = meshHierarchy_(ii).transferMat(kk,:);
			xFiner(tmp2,jj) = xFiner(tmp2,jj) + tmp1(kk,:)';
		end			
	end
	xFiner = xFiner ./ meshHierarchy_(ii).transferMatCoeffi;
	xFiner = xFiner(meshHierarchy_(ii).solidNodeMapCoarser2Finer,:);
	xFiner = reshape(xFiner', 3*meshHierarchy_(ii-1).numNodes, 1);
end