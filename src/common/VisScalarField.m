function VisScalarField(scalarField, varargin)
	global meshHierarchy_;
	global U_;
	global nodeCoords_;
	global boundingBox_;
	
	if 1==nargin
		minFeaterSize = min(boundingBox_(2,:)-boundingBox_(1,:)); selfFac = 10;
		scalingFactor = minFeaterSize/selfFac/max(abs(U_));		
	elseif 2==nargin
		scalingFactor = varargin{1};
	else
		error('Wrong Input!');
	end
	deformation = U_ * scalingFactor;
	numElesOnBound = numel(meshHierarchy_(1).elementsOnBoundary);
	patchIndices = meshHierarchy_(1).eNodMat(meshHierarchy_(1).elementsOnBoundary,[4 3 2 1  5 6 7 8  1 2 6 5  8 7 3 4  5 8 4 1  2 3 7 6])';
	patchIndices = reshape(patchIndices(:), 4, 6*numElesOnBound);		
	
	allNodes = zeros(meshHierarchy_(1).numNodes,1);
	allNodes(meshHierarchy_(1).nodesOnBoundary) = 1;
	allNodes = allNodes(patchIndices');
	allNodes = sum(allNodes,2);
	patchIndices = patchIndices(:,find(4==allNodes)');					
	deformation = reshape(deformation, 3, meshHierarchy_(1).numNodes)';
	deformedCartesianGrid = nodeCoords_(meshHierarchy_(1).nodMapBack,:) + deformation;
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
	set(h,'Ticks',linspace(t(1),t(2),7),'AxisLocation','out');	
	L=cellfun(@(x)sprintf('%.2e',x),num2cell(linspace(t(1),t(2),7)),'Un',0); 
	set(h,'xticklabel',L);		
	axis(axHandle, 'off'); axis(axHandle, 'equal'); axis(axHandle, 'tight');
	set(axHandle, 'FontName', 'Times New Roman', 'FontSize', 20);		
end