function K = DirectlyAssembleStifnessMatrix(iLevel)
	global meshHierarchy_;
	global Ke0_;
	if iLevel>length(meshHierarchy_)
		error('Exceeds the maximum level!');
	end
	if 1==iLevel %%just for test		
		semiKe = tril(Ke0_); semiKe = sparse(semiKe); 
		[rowIndice colIndice semiKe] = find(semiKe);
		eDofMat = [3*meshHierarchy_(1).eNodMat-2 3*meshHierarchy_(1).eNodMat-1 ...
			3*meshHierarchy_(1).eNodMat];
		eDofMat = eDofMat(:,[1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);	
		blockIndex = MissionPartition(meshHierarchy_(1).numElements, 1.0e6);
		K = sparse(meshHierarchy_(1).numDOFs, meshHierarchy_(1).numDOFs);
		for ii=1:size(blockIndex,1)
			rangeIndex = (blockIndex(ii,1):blockIndex(ii,2))';
			sK = repmat(semiKe, 1, length(rangeIndex));
			iK = eDofMat(rangeIndex,rowIndice);
			jK = eDofMat(rangeIndex,colIndice);
			tmpK = sparse(iK, jK, sK', meshHierarchy_(1).numDOFs, meshHierarchy_(1).numDOFs);					
			tmpK = tmpK + tmpK' - diag(diag(tmpK));
			K = K + tmpK;
		end	
	else %%assembling system stiffness matrix on coarsest level
		[rowIndice, colIndice, ~] = find(ones(24));	
		sK = zeros(24^2, meshHierarchy_(end).numElements);
		for ii=1:meshHierarchy_(end).numElements
			sK(:,ii) = reshape(meshHierarchy_(end).Ks(:,:,ii), 24^2, 1);
		end
		iK = meshHierarchy_(end).eDofMat(:,rowIndice);
		jK = meshHierarchy_(end).eDofMat(:,colIndice);
		K = sparse(iK, jK, sK');
		meshHierarchy_(end).Ks = [];
	end
end