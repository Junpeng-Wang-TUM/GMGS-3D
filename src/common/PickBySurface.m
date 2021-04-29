function PickByLine(constantDir)
	global boundaryNodeCoords_;
	global PickedNodeCache_;
	global hdPickedNode_;
	
	dcm_obj = datacursormode;
	info_struct = getCursorInfo(dcm_obj);
	if isempty(info_struct)
		warning('No Cursor Mode Available!'); return;
	end
	tarNode = info_struct.Position;
	numPickedNode = size(PickedNodeCache_,1);
	hold on; 
	if 1~=length(constantDir), error('Wrongly Defined Line Direction!'); end
	switch constantDir
		case 'X'
			nodesOnLine = find(boundaryNodeCoords_(:,1)==tarNode(1));
		case 'Y'
			nodesOnLine = find(boundaryNodeCoords_(:,2)==tarNode(2));
		case 'Z'
			nodesOnLine = find(boundaryNodeCoords_(:,3)==tarNode(3));				
		otherwise
			error('Wrongly Defined Line Direction!');
	end	
	hdPickedNode_(end+1) = plot3(boundaryNodeCoords_(nodesOnLine,1), boundaryNodeCoords_(nodesOnLine,2), ...
		boundaryNodeCoords_(nodesOnLine,3), 'xr', 'LineWidth', 2, 'MarkerSize', 10);
	numNewlyPickedNodes = length(nodesOnLine);
	PickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesOnLine;
end