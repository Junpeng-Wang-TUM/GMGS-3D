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
		patchIndices = zeros(4,6*numElesOnBound);
		mapEle2patch = [4 3 2 1; 5 6 7 8; 1 2 6 5; 8 7 3 4; 5 8 4 1; 2 3 7 6]';
		for ii=1:numElesOnBound
			index = (ii-1)*6;
			iEleVtx = iMesh.eNodMat(iMesh.elementsOnBoundary(ii),:)';
			patchIndices(:,index+1:index+6) = iEleVtx(mapEle2patch);
		end
		allNodes = zeros(iMesh.numNodes,1);
		allNodes(iMesh.nodesOnBoundary) = 1;
		allNodes = allNodes(patchIndices');
		allNodes = sum(allNodes,2);
		patchIndices = patchIndices(:,find(4==allNodes)');
		tarNodeCoords = nodeCoords_(iMesh.solidNodesMapVec,:);
		xPatchs = tarNodeCoords(:,1); xPatchs = xPatchs(patchIndices);
		yPatchs = tarNodeCoords(:,2); yPatchs = yPatchs(patchIndices);
		zPatchs = tarNodeCoords(:,3); zPatchs = zPatchs(patchIndices);
		cPatchs = zeros(size(xPatchs));		
	else
		error('Wrong type of input mesh!');
	end

	hd = patch(xPatchs, yPatchs, zPatchs, cPatchs);	
	set(hd, 'FaceColor', [65 174 118]/255, 'FaceAlpha', 1, 'EdgeColor', 'None');
	axis('on'); axis('equal'); axis('tight');
	view(3); camproj('perspective');
	lighting('gouraud');
	camlight('headlight','infinite');
	camlight('right','infinite');
	camlight('left','infinite');
	material('metal');
	xlabel('X'); ylabel('Y'); zlabel('Z');
	set(gca, 'FontName', 'Times New Roman', 'FontSize', 20);
end