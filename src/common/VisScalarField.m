function VisScalarField(scalarField, scalingFactor)
	global meshHierarchy_;
	global U_;
	global nodeCoords_;
	global domainUpperBound_; global domainLowerBound_;	
	
	if isempty(scalingFactor)
		minFeaterSize = min(domainUpperBound_-domainLowerBound_); selfFac = 10;
		scalingFactor = minFeaterSize/selfFac/max(U_);
	end	
	deformation = U_ * scalingFactor;
	numElesOnBound = numel(meshHierarchy_(1).elementsOnBoundary);
	patchIndices = zeros(4,6*numElesOnBound);
	mapEle2patch = [4 3 2 1; 5 6 7 8; 1 2 6 5; 8 7 3 4; 5 8 4 1; 2 3 7 6]';
	for ii=1:1:numElesOnBound
		index = (ii-1)*6;
		iEleVtx = meshHierarchy_(1).eNodMat(...
			meshHierarchy_(1).elementsOnBoundary(ii),:)';
		patchIndices(:,index+1:index+6) = iEleVtx(mapEle2patch);
	end
	allNodes = zeros(meshHierarchy_(1).numNodes,1);
	allNodes(meshHierarchy_(1).nodesOnBoundary) = 1;
	allNodes = allNodes(patchIndices');
	allNodes = sum(allNodes,2);
	patchIndices = patchIndices(:,find(4==allNodes)');					
	deformation = reshape(deformation, 3, meshHierarchy_(1).numNodes)';
	deformedCartesianGrid = nodeCoords_(meshHierarchy_(1).solidNodesMapVec,:) + deformation;
	xPatchs = deformedCartesianGrid(:,1); xPatchs = xPatchs(patchIndices);
	yPatchs = deformedCartesianGrid(:,2); yPatchs = yPatchs(patchIndices);
	zPatchs = deformedCartesianGrid(:,3); zPatchs = zPatchs(patchIndices);
	cPatchs = scalarField(patchIndices);
	
	figure; axHandle = gca;
	hd = patch(axHandle, xPatchs, yPatchs, zPatchs, cPatchs); hold(axHandle, 'on');
	camproj(axHandle, 'perspective'); view(axHandle, 3); 	
	colormap('jet');
	set(hd, 'FaceColor', 'interp', 'FaceAlpha', 1, 'EdgeColor', 'none');
	h = colorbar; t=get(h,'Limits'); 
	set(h,'Ticks',linspace(t(1),t(2),5),'AxisLocation','out');	
	L=cellfun(@(x)sprintf('%.2e',x),num2cell(linspace(t(1),t(2),5)),'Un',0); 
	set(h,'xticklabel',L);		
	axis(axHandle, 'off'); axis(axHandle, 'equal'); axis(axHandle, 'tight');
	set(axHandle, 'FontName', 'Times New Roman', 'FontSize', 20);		
end