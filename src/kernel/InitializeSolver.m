function InitializeSolver()
	global meshHierarchy_;
	global F_; 
	global Ke0_;
	global numLevels_;
	global cholFac_; global cholPermut_;
	
	%%1. initialize system matrix
	Ke0_ = InitializeElementStiffnessMatrix();
	meshHierarchy_(1).storingState = 0;					
	meshHierarchy_(1).Ke = Ke0_;
	meshHierarchy_(1).Ks = meshHierarchy_(1).Ke;	
	meshHierarchy_(1).eDofMat = [3*meshHierarchy_(1).eNodMat-2 3*meshHierarchy_(1).eNodMat-1 3*meshHierarchy_(1).eNodMat];
	reOrdering = [1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24];
	meshHierarchy_(1).eDofMat = meshHierarchy_(1).eDofMat(:, reOrdering);
	
	%%2. Building Mesh Hierarchy
	BuildingMeshHierarchy();
	if numLevels_<2 
		error('There is no sufficient resolution to invoke GMGS!');
	end

	%%3. Basic data preparation, for index-based matrix-by-vector, only directly storing stiffness matrices on the >3 levels
	spanWidth = 2;
	interpolatingKe = Operator4MultiGridRestrictionAndInterpolation('inDOF',spanWidth);
	eNodMat4Finer2Coarser = SubEleNodMat(spanWidth);
	[rowIndice, colIndice, ~] = find(ones(24));
	eDofMat4Finer2Coarser = [3*eNodMat4Finer2Coarser-2 3*eNodMat4Finer2Coarser-1 3*eNodMat4Finer2Coarser];
	eDofMat4Finer2Coarser = eDofMat4Finer2Coarser(:, [1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);
	iK = eDofMat4Finer2Coarser(:,rowIndice)';
	jK = eDofMat4Finer2Coarser(:,colIndice)';
	numProjectDOFs = (spanWidth+1)^3*3;
	
	%%4. compute index-based system stiffness matrix on coarser levels
	eleStiffnessMatStateOnFinerLevel = [];
	for ii=2:numLevels_
		meshHierarchy_(ii).Ke = Ke0_*(meshHierarchy_(ii).eleSize(1)/meshHierarchy_(1).eleSize(1));	
		numElements = meshHierarchy_(ii).numElements;
		if 2==ii
			if numLevels_>2
				meshHierarchy_(ii).storingState = 2;
				elementUpwardMap = meshHierarchy_(ii).elementUpwardMap;
				[~, iCol] = find(0==elementUpwardMap');
				uniqueElements = int32(unique(iCol));
				universalElements = setdiff((1:int32(numElements))', uniqueElements);
				numUniqueElements = length(uniqueElements);
				Ks = meshHierarchy_(ii).Ke;	
				if numUniqueElements>0
					solidFinerKes = reshape(meshHierarchy_(ii-1).Ke, 24*24, 1);
					solidFinerKes = repmat(solidFinerKes, 1, spanWidth^3);
					Ks = repmat(Ks,1,1,1+numUniqueElements);
					for jj=1:numUniqueElements
						iCoarseEle = uniqueElements(jj);
						iFinerEles = elementUpwardMap(iCoarseEle,:);
						voidEles = find(0==iFinerEles);
						sK = solidFinerKes; sK(:,voidEles) = 0;
						tmpK = sparse(iK, jK, sK, numProjectDOFs, numProjectDOFs);
						tmpK = interpolatingKe' * tmpK * interpolatingKe;
						Ks(:,:,jj+1) = full(tmpK);
					end
					eleStiffnessMatStateOnFinerLevel = ones(numElements,1);
					eleStiffnessMatStateOnFinerLevel(uniqueElements) = (2:1+numUniqueElements)';							
				else
					eleStiffnessMatStateOnFinerLevel = ones(numElements,1);
				end
				meshHierarchy_(ii).Ks = Ks;
				meshHierarchy_(ii).uniqueElements = uniqueElements;
				meshHierarchy_(ii).universalElements = universalElements;
			else
				meshHierarchy_(ii).storingState = 1;
				Ks = repmat(meshHierarchy_(ii).Ke,1,1,numElements);
				iKes = reshape(meshHierarchy_(ii-1).Ke, 24^2,1);
				elementUpwardMap = meshHierarchy_(ii).elementUpwardMap;
				voidFinerKes = zeros(24*24, spanWidth^3);
				for jj=1:numElements
					iFinerEles = elementUpwardMap(jj,:);
					[~, solidEles] = find(0~=iFinerEles);
					sK = voidFinerKes;
					for kk=1:length(solidEles)
						sK(:,solidEles(kk)) = iKes;
					end
					tmpK = sparse(iK, jK, sK, numProjectDOFs, numProjectDOFs);
					tmpK = interpolatingKe' * tmpK * interpolatingKe;
					Ks(:,:,jj) = full(tmpK);								
				end
				meshHierarchy_(ii).Ks = Ks;				
			end
			continue;
		end
		if 3==ii 
			if numLevels_>3
				meshHierarchy_(ii).storingState = 2;
				elementUpwardMapPrevious = meshHierarchy_(ii-1).elementUpwardMap;
				elementUpwardMapCurrent = meshHierarchy_(ii).elementUpwardMap;
				uniqueElements = [];				
				for jj=1:numElements
					tmp0 = elementUpwardMapCurrent(jj,:)';
					tmp0 = tmp0(0~=tmp0);
					tmp = elementUpwardMapPrevious(tmp0,:);
					if find(0==tmp), uniqueElements(end+1,1) = jj; end
				end
				uniqueElements = int32(uniqueElements);
				universalElements = setdiff((1:int32(numElements))', uniqueElements);
				numUniqueElements = length(uniqueElements);
				Ks = meshHierarchy_(ii).Ke;						
				if numUniqueElements>0
					voidFinerKes = zeros(24*24, spanWidth^3);							
					Ks = repmat(Ks,1,1,1+numUniqueElements);
					KsPrevious = meshHierarchy_(ii-1).Ks;
					for jj=1:numUniqueElements
						iCoarseEle = uniqueElements(jj);
						iFinerEles = elementUpwardMapCurrent(iCoarseEle,:);
						[~, solidEles] = find(0~=iFinerEles);
						iFinerEles = iFinerEles(solidEles);
						iKes = KsPrevious(:,:,eleStiffnessMatStateOnFinerLevel(iFinerEles));
						sK = voidFinerKes;
						for kk=1:length(solidEles)
							sK(:,solidEles(kk)) = reshape(iKes(:,:,kk),24^2,1);
						end
						tmpK = sparse(iK, jK, sK, numProjectDOFs, numProjectDOFs);
						tmpK = interpolatingKe' * tmpK * interpolatingKe;
						Ks(:,:,jj+1) = full(tmpK);
					end							
					eleStiffnessMatStateOnFinerLevel = ones(numElements,1);
					eleStiffnessMatStateOnFinerLevel(uniqueElements) = (2:1+numUniqueElements)';
				else
					eleStiffnessMatStateOnFinerLevel = ones(numElements,1);
				end
				meshHierarchy_(ii).Ks = Ks;
				meshHierarchy_(ii).uniqueElements = uniqueElements;
				meshHierarchy_(ii).universalElements = universalElements;
			else
				meshHierarchy_(ii).storingState = 1;
				Ks = repmat(meshHierarchy_(ii).Ke,1,1,numElements);
				KsPrevious = meshHierarchy_(ii-1).Ks;
				elementUpwardMap = meshHierarchy_(ii).elementUpwardMap;						
				voidFinerKes = zeros(24*24, spanWidth^3);
				for jj=1:numElements
					iFinerEles = elementUpwardMap(jj,:);
					[~, solidEles] = find(0~=iFinerEles);
					iFinerEles = iFinerEles(solidEles);
					iKes = KsPrevious(:,:,eleStiffnessMatStateOnFinerLevel(iFinerEles));
					sK = voidFinerKes;
					for kk=1:length(solidEles)
						sK(:,solidEles(kk)) = reshape(iKes(:,:,kk),24^2,1);
					end
					tmpK = sparse(iK, jK, sK, numProjectDOFs, numProjectDOFs);
					tmpK = interpolatingKe' * tmpK * interpolatingKe;
					Ks(:,:,jj) = full(tmpK);
				end
				meshHierarchy_(ii).Ks = Ks;		
			end
			continue;
		end
		if 4==ii
			meshHierarchy_(ii).storingState = 1;
			Ks = repmat(meshHierarchy_(ii).Ke,1,1,numElements);
			KsPrevious = meshHierarchy_(ii-1).Ks;
			elementUpwardMap = meshHierarchy_(ii).elementUpwardMap;						
			voidFinerKes = zeros(24*24, spanWidth^3);
			for jj=1:numElements
				iFinerEles = elementUpwardMap(jj,:);
				[~, solidEles] = find(0~=iFinerEles);
				iFinerEles = iFinerEles(solidEles);
				iKes = KsPrevious(:,:,eleStiffnessMatStateOnFinerLevel(iFinerEles));
				sK = voidFinerKes;
				for kk=1:length(solidEles)
					sK(:,solidEles(kk)) = reshape(iKes(:,:,kk),24^2,1);
				end
				tmpK = sparse(iK, jK, sK, numProjectDOFs, numProjectDOFs);
				tmpK = interpolatingKe' * tmpK * interpolatingKe;
				Ks(:,:,jj) = full(tmpK);
			end
			meshHierarchy_(ii).Ks = Ks;
			continue;
		end	
		meshHierarchy_(ii).storingState = 1;
		Ks = repmat(meshHierarchy_(ii).Ke,1,1,numElements);
		KsPrevious = meshHierarchy_(ii-1).Ks;
		elementUpwardMap = meshHierarchy_(ii).elementUpwardMap;
		voidFinerKes = zeros(24*24, spanWidth^3);
		for jj=1:numElements
			iFinerEles = elementUpwardMap(jj,:);
			[~, solidEles] = find(0~=iFinerEles);
			iFinerEles = iFinerEles(solidEles);
			iKes = KsPrevious(:,:,iFinerEles);
			sK = voidFinerKes;
			for kk=1:length(solidEles)
				sK(:,solidEles(kk)) = reshape(iKes(:,:,kk),24^2,1);
			end
			tmpK = sparse(iK, jK, sK, numProjectDOFs, numProjectDOFs);
			tmpK = interpolatingKe' * tmpK * interpolatingKe;
			Ks(:,:,jj) = full(tmpK);								
		end
		meshHierarchy_(ii).Ks = Ks;
	end	
	
	for ii=2:numLevels_					
		meshHierarchy_(ii).eDofMat = [3*meshHierarchy_(ii).eNodMat-2 3*meshHierarchy_(ii).eNodMat-1 3*meshHierarchy_(ii).eNodMat];
		meshHierarchy_(ii).eDofMat = meshHierarchy_(ii).eDofMat(:, [1 9 17 2 10 18 3 11 19 4 12 20 5 13 21 6 14 22 7 15 23 8 16 24]);			
	end
	
	%%5. initialize smoother
	for ii=1:length(meshHierarchy_)-1
		diagK = zeros(meshHierarchy_(ii).numDOFs,1);
		eDofMat = meshHierarchy_(ii).eDofMat;
		numElements = meshHierarchy_(ii).numElements;
		switch meshHierarchy_(ii).storingState
			case 0
				diagKe = diag(meshHierarchy_(ii).Ks);							
				for jj=1:numElements
					dofIndex = eDofMat(jj,:)';
					diagK(dofIndex) = diagK(dofIndex) + diagKe;
				end						
			case 1
				Ks = meshHierarchy_(ii).Ks;
				for jj=1:numElements
					dofIndex = eDofMat(jj,:)';
					Ke = Ks(:,:,jj);
					diagK(dofIndex) = diagK(dofIndex) + diag(Ke);
				end
			case 2
				Ks = meshHierarchy_(ii).Ks;
				numUniqueEles = length(meshHierarchy_(ii).uniqueElements);
				if numUniqueEles>0
					uniqueElements = meshHierarchy_(ii).uniqueElements;
					for jj=1:numUniqueEles
						dofIndex = eDofMat(uniqueElements(jj),:)';
						Ke = Ks(:,:,jj+1);
						diagK(dofIndex) = diagK(dofIndex) + diag(Ke);
					end						
				end
				numUniversalElements = length(meshHierarchy_(ii).universalElements);
				if numUniversalElements>0
					diagKe = diag(Ks(:,:,1));
					universalElements = meshHierarchy_(ii).universalElements;
					for jj=1:numUniversalElements
						dofIndex = eDofMat(universalElements(jj),:)';
						diagK(dofIndex) = diagK(dofIndex) + diagKe;
					end
				end						
		end			
		meshHierarchy_(ii).diagK = diagK;			
	end	
	
	%%6. transfer boundary condition to coaser levels
	fixedDOFsOnFiner = zeros(meshHierarchy_(1).numDOFs,1);
	fixedDOFsOnFiner(meshHierarchy_(1).fixedDOFs) = 1;		
	for ii=2:numLevels_
		forcesOnCoarser = RestrictResidual(fixedDOFsOnFiner,ii);
		meshHierarchy_(ii).freeDOFs = int32(find(0==forcesOnCoarser));
		meshHierarchy_(ii).fixedDOFs = setdiff((1:int32(meshHierarchy_(ii).numDOFs))', meshHierarchy_(ii).freeDOFs);
		fixedDOFsOnFiner = forcesOnCoarser;
	end

	%%7. assemble&factorize stiffness matrix on coarsest level
	KcoarsestLevel = DirectlyAssembleStifnessMatrix(length(meshHierarchy_));
	KcoarsestLevel = KcoarsestLevel(meshHierarchy_(end).freeDOFs, meshHierarchy_(end).freeDOFs);
	[cholFac_, flag, cholPermut_] = chol(KcoarsestLevel, 'lower');			
end
