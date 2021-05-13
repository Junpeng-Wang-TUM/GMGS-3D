function hd = VisSurfaceMesh(iMesh)
	global nodeCoords_;
	patchIndices = [];
	patchType = size(iMesh.eNodMat,2);
	if 3==patchType
		patchIndices = iMesh.eNodMat';
		xPatchs = iMesh.nodeCoords(:,1); xPatchs = xPatchs(patchIndices);
		yPatchs = iMesh.nodeCoords(:,2); yPatchs = yPatchs(patchIndices);
		zPatchs = iMesh.nodeCoords(:,3); zPatchs = zPatchs(patchIndices);
		cPatchs = zeros(size(xPatchs));	
	elseif 8==patchType		
		numElesOnBound = numel(iMesh.elementsOnBoundary);
		patchIndices = iMesh.eNodMat(iMesh.elementsOnBoundary,[4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
		patchIndices = reshape(patchIndices(:), 4, 6*numElesOnBound);	
		
		allNodes = zeros(iMesh.numNodes,1);
		allNodes(iMesh.nodesOnBoundary) = 1;
		allNodes = allNodes(patchIndices');
		allNodes = sum(allNodes,2);
		patchIndices = patchIndices(:,find(4==allNodes)');
		tarNodeCoords = nodeCoords_(iMesh.nodMapBack,:);
		xPatchs = tarNodeCoords(:,1); xPatchs = xPatchs(patchIndices);
		yPatchs = tarNodeCoords(:,2); yPatchs = yPatchs(patchIndices);
		zPatchs = tarNodeCoords(:,3); zPatchs = zPatchs(patchIndices);
		cPatchs = zeros(size(xPatchs));	
	else
		error('Wrong type of input mesh!');
	end
	hd = patch(xPatchs, yPatchs, zPatchs, cPatchs);
	set(hd, 'FaceColor', [65 174 118]/255, 'FaceAlpha', 1, 'EdgeColor', 'k');	
	camproj('perspective');
	axis('on'); axis('equal'); axis('tight');
	[az, el] = view(3); 
	% [az, el] = view(-1.623917302580646e+02, 7.357713248192212e+00);
	lighting('gouraud');
	camlight(az,el,'infinite');
	camlight('headlight','infinite');
	material('dull');
	xlabel('X'); ylabel('Y'); zlabel('Z');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
end