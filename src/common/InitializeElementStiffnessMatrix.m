function Ke = InitializeElementStiffnessMatrix()
	global meshHierarchy_;
	global nodeCoords_;
	[s, t, p, w] = GaussianIntegral();
	dShape = DeShapeFunction(s,t,p);	
	eleD = ElementElasticityMatrix();
	numNodeDOFs = 3;
	numGIPs = 8;
	detJ = zeros(numGIPs,1); 	
	invJ = HDSparseMatStruct(numNodeDOFs*numGIPs, numNodeDOFs*numGIPs);
	for jj=1:numGIPs
		relatedNod = meshHierarchy_(1).eNodMat(1,:);
		relatedNod = meshHierarchy_(1).solidNodesMapVec(relatedNod);
		relativeNodCoord = nodeCoords_(relatedNod,:);
		[detJ(jj), invJ.SPmat(numNodeDOFs*(jj-1)+1:numNodeDOFs*jj, numNodeDOFs*(jj-1)+1:numNodeDOFs*jj)] = ...
			JacobianMat(dShape(numNodeDOFs*(jj-1)+1:numNodeDOFs*jj,:), relativeNodCoord);			
	end
	eleB = ElementStrainMatrix(dShape, invJ.SPmat);
	
	wgt = w.*detJ;	wgt = repmat(wgt, 1, 6);
	wgt = reshape(wgt', 1, numel(wgt));
	Ke = eleB'*(eleD.*wgt)*eleB;	
end