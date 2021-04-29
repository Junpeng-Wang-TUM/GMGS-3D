function PickByCircle()
	global boundaryNodeCoords_;
	global PickedNodeCache_;
	global hdPickedNode_;
	if size(PickedNodeCache_, 1) < 2, 
		warning('There MUST be at lease TWO Picked Nodes Available!'); return;
	end
	ctr = boundaryNodeCoords_(PickedNodeCache_(end-1),:);
	radi = norm(ctr-boundaryNodeCoords_(PickedNodeCache_(end),:));
	nodesWithinCircle = find(vecnorm(ctr-boundaryNodeCoords_,2,2)<=radi);
	nodesWithinCircle = setdiff(nodesWithinCircle, PickedNodeCache_(end-1:end));
	hdPickedNode_(end+1) = plot3(boundaryNodeCoords_(nodesWithinCircle,1), boundaryNodeCoords_(nodesWithinCircle,2), ...
		boundaryNodeCoords_(nodesWithinCircle,3), 'xr', 'LineWidth', 2, 'MarkerSize', 10);
	numNewlyPickedNodes = length(nodesWithinCircle);
	PickedNodeCache_(end+1:end+numNewlyPickedNodes,1) = nodesWithinCircle;
end