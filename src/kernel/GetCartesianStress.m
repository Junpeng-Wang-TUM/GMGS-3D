function GetCartesianStress()	
	%% stress tensor = [Sigma_xx, Sigma_yy, Sigma_zz, Sigma_yz, Sigma_zx, Sigma_xy];
	global U_;
	global nodeCoords_; global meshHierarchy_;	
	global numNod2ElesVec_;	
	global cartesianStressField_;	
	if isempty(U_)
		warning('No Deformation Field Available, Please Compute Deformation First by running FUNCTION GetDeformation!'); return;
	end

	numNode = 8;
	numNodeDOFs = 3;
	numStressComponents =6;
	numGIPs = 8;
	numEntries = numNode*numNodeDOFs;
	cartesianStressField_ = zeros(meshHierarchy_(1).numNodes, numStressComponents);
	OTP = OuterInterpolationMat();
	
	[s, t, p, ~] = GaussianIntegral();
	N = ShapeFunction(s, t, p);
	dShape = DeShapeFunction(s,t,p);
	eleD = ElementElasticityMatrix();	
	invJ = zeros(numNodeDOFs*numGIPs, numNodeDOFs*numGIPs);
	iNode = meshHierarchy_(1).eNodMat(1,:)';
	iNode = meshHierarchy_(1).nodMapBack(iNode);			
	probeEleNods = nodeCoords_(iNode,:);		
	for jj=1:numGIPs
		jacMat = dShape(numNodeDOFs*(jj-1)+1:numNodeDOFs*jj,:)*probeEleNods;
		invJ(numNodeDOFs*(jj-1)+1:numNodeDOFs*jj, numNodeDOFs*(jj-1)+1:numNodeDOFs*jj) = inv(jacMat);
	end
	eleB = ElementStrainMatrix(dShape, invJ);
	for ii=1:meshHierarchy_(1).numElements
		relativeDOFsIndex = meshHierarchy_(1).eDofMat(ii,:);
		u = U_(relativeDOFsIndex,1);
		cartesianStressOnGaussIntegralPoints = eleD * (eleB*u);	
		midVar = OTP*cartesianStressOnGaussIntegralPoints;
		midVar = reshape(midVar, numStressComponents, numNode)';
		relativeNodesIndex = meshHierarchy_(1).eNodMat(ii,:);
		cartesianStressField_(relativeNodesIndex,:) = midVar + cartesianStressField_(relativeNodesIndex,:);
	end
	cartesianStressField_ = cartesianStressField_./numNod2ElesVec_;	
end

function outerInterpolationMatrix = OuterInterpolationMat()
	[s, t, p, ~] = GaussianIntegral();
	N = ShapeFunction(s,t,p);
	sFM = sparse(48,48);
	ii = 6*(1:8);
	sFM(1,ii-5) = N(1,:); sFM(2,ii-4) = N(1,:); sFM(3,ii-3) = N(1,:);
	sFM(4,ii-2) = N(1,:); sFM(5,ii-1) = N(1,:); sFM(6,ii) = N(1,:);
	
	sFM(7,ii-5) = N(2,:); sFM(8,ii-4) = N(2,:); sFM(9,ii-3) = N(2,:);
	sFM(10,ii-2) = N(2,:); sFM(11,ii-1) = N(2,:); sFM(12,ii) = N(2,:);

	sFM(13,ii-5) = N(3,:); sFM(14,ii-4) = N(3,:); sFM(15,ii-3) = N(3,:);
	sFM(16,ii-2) = N(3,:); sFM(17,ii-1) = N(3,:); sFM(18,ii) = N(3,:);	

	sFM(19,ii-5) = N(4,:); sFM(20,ii-4) = N(4,:); sFM(21,ii-3) = N(4,:);
	sFM(22,ii-2) = N(4,:); sFM(23,ii-1) = N(4,:); sFM(24,ii) = N(4,:);

	sFM(25,ii-5) = N(5,:); sFM(26,ii-4) = N(5,:); sFM(27,ii-3) = N(5,:);
	sFM(28,ii-2) = N(5,:); sFM(29,ii-1) = N(5,:); sFM(30,ii) = N(5,:);	

	sFM(31,ii-5) = N(6,:); sFM(32,ii-4) = N(6,:); sFM(33,ii-3) = N(6,:);
	sFM(34,ii-2) = N(6,:); sFM(35,ii-1) = N(6,:); sFM(36,ii) = N(6,:);	

	sFM(37,ii-5) = N(7,:); sFM(38,ii-4) = N(7,:); sFM(39,ii-3) = N(7,:);
	sFM(40,ii-2) = N(7,:); sFM(41,ii-1) = N(7,:); sFM(42,ii) = N(7,:);	

	sFM(43,ii-5) = N(8,:); sFM(44,ii-4) = N(8,:); sFM(45,ii-3) = N(8,:);
	sFM(46,ii-2) = N(8,:); sFM(47,ii-1) = N(8,:); sFM(48,ii) = N(8,:);		
	outerInterpolationMatrix = inv(sFM);
end