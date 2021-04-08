function v = AtX(x1, varargin)	
	global meshHierarchy_;
	if 1==nargin, iLevel = 1; else, iLevel = varargin{1}; end
	v = zeros(meshHierarchy_(iLevel).numDOFs,1);
	switch meshHierarchy_(iLevel).storingState
		case 0
			blockIndex = MissionPartition(meshHierarchy_(iLevel).numElements, 5.0e6);		
			Ks = meshHierarchy_(iLevel).Ks;
			for jj=1:size(blockIndex,1)
				rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
				iElesDofMat = meshHierarchy_(iLevel).eDofMat(rangeIndex,:);									
				vEleWise = x1(iElesDofMat)*Ks;
				for ii=1:24
					tmp = iElesDofMat(:,ii);
					v(tmp) = v(tmp) + vEleWise(:,ii);
				end		
			end	
		case 1	
			x1 = x1(meshHierarchy_(iLevel).eDofMat);
			Ks = meshHierarchy_(iLevel).Ks;
			numElements = meshHierarchy_(iLevel).numElements;
			for ii=1:numElements
				x1(ii,:) = x1(ii,:)*Ks(:,:,ii);
			end	
			for ii=1:24
				tmp = meshHierarchy_(iLevel).eDofMat(:,ii);
				v(tmp) = v(tmp) + x1(:,ii);
			end			
		case 2		
			%%1. A*x on boundary (the unique element stiffness matrice)
			iElesDofMat = meshHierarchy_(iLevel).eDofMat(meshHierarchy_(iLevel).uniqueElements,:);
			x1OnBoundary = x1(iElesDofMat);
			numUniqueEles = size(iElesDofMat,1);
			Ks = meshHierarchy_(iLevel).Ks;
			if numUniqueEles>0
				for ii=1:numUniqueEles
					x1OnBoundary(ii,:) = x1OnBoundary(ii,:)*Ks(:,:,ii+1);
				end
				for ii=1:24
					tmp = iElesDofMat(:,ii);
					v(tmp) = v(tmp) + x1OnBoundary(:,ii);
				end			
			end
			%%2. A*x inside (the universal element stiffness matrix)
			blockIndex = MissionPartition(length(meshHierarchy_(iLevel).universalElements), 5.0e6);
			for jj=1:size(blockIndex,1)
				rangeIndex = (blockIndex(jj,1):blockIndex(jj,2))';
				rangeIndex = meshHierarchy_(iLevel).universalElements(rangeIndex);
				iElesDofMat = meshHierarchy_(iLevel).eDofMat(rangeIndex,:);
				vEleWise = x1(iElesDofMat)*Ks(:,:,1);
				for ii=1:24
					tmp = iElesDofMat(:,ii);
					v(tmp) = v(tmp) + vEleWise(:,ii);
				end
			end				
	end
	v(meshHierarchy_(iLevel).fixedDOFs) = 0;		
end
