function Ke = InitializeElementStiffnessMatrix()
	global meshHierarchy_;
	global nodeCoords_;
	[s, t, p, w] = GaussianIntegral();
	dShape = DeShapeFunction(s,t,p);	
	eleD = ElementElasticityMatrix();
	numNodeDOFs = 3;
	numGIPs = 8;
	detJ = zeros(numGIPs,1); 	
	invJ = zeros(numNodeDOFs*numGIPs, numNodeDOFs*numGIPs);
	iNode = meshHierarchy_(1).eNodMat(1,:)';
	iNode = meshHierarchy_(1).nodMapBack(iNode);			
	probeEleNods = nodeCoords_(iNode,:);			
	for jj=1:numGIPs
		jacMat = dShape(numNodeDOFs*(jj-1)+1:numNodeDOFs*jj,:)*probeEleNods;
		detJ(jj) = det(jacMat);
		invJ(numNodeDOFs*(jj-1)+1:numNodeDOFs*jj, numNodeDOFs*(jj-1)+1:numNodeDOFs*jj) = inv(jacMat);			
	end
	eleB = ElementStrainMatrix(dShape, invJ);
	wgt = w.*detJ;	wgt = repmat(wgt, 1, 6);
	wgt = reshape(wgt', 1, numel(wgt));
	Ke = eleB'*(eleD.*wgt)*eleB;	
end