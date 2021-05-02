function PickBySurface(constantDir, opt, varargin)
	global boundaryNodeCoords_;
	global PickedNodeCache_;
	global hdPickedNode_;
	
	dcm_obj = datacursormode;
	info_struct = getCursorInfo(dcm_obj);
	if isempty(info_struct)
		warning('No Cursor Mode Available!'); return;
	end
	if ~(1==opt || 0==opt || -1==opt), warning('Wrong Input!'); return; end
	if 0==opt
		if 2==nargin, surfRelaxFactor = 0; else, surfRelaxFactor = varargin{1}; end
	end	
	tarNode = info_struct.Position;
	numPickedNode = size(PickedNodeCache_,1);
	hold on; 
	if 1~=length(constantDir), error('Wrongly Defined Line Direction!'); end
	switch constantDir
		case 'X'
			refNodePool = boundaryNodeCoords_(:,1);
			refPos = tarNode(1);				
		case 'Y'
			refNodePool = boundaryNodeCoords_(:,2);
			refPos = tarNode(2);				
		case 'Z'
			refNodePool = boundaryNodeCoords_(:,3);
			refPos = tarNode(3);				
		otherwise
			error('Wrongly Defined Line Direction!');
	end
	switch opt
		case 1
			nodesOnLine = find(refNodePool>=refPos);
		case 0
			nodesOnLine = find(abs(refNodePool-refPos)<=surfRelaxFactor);
		case -1
			nodesOnLine = find(refNodePool<=refPos);
	end	
	hdPickedNode_(end+1) = plot3(boundaryNodeCoords_(nodesOnLine,1), boundaryNodeCoords_(nodesOnLine,2), ...
		boundaryNodeCoords_(nodesOnLine,3), 'xr', 'LineWidth', 2, 'MarkerSize', 10);
	numNewlyPickedNodes = length(nodesOnLine);
	PickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesOnLine;
end