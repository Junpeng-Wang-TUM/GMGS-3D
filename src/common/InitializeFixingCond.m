function InitializeFixingCond(varargin)
	global meshHierarchy_;
	global nodeCoords_;
	global fixingCond_;
	global PickedNodeCache_;
	ndC = nodeCoords_(meshHierarchy_(1).solidNodesMapVec(meshHierarchy_(1).nodesOnBoundary),:);
	if isempty(PickedNodeCache_), warning('There is no node selected!'); end
	if 0==nargin
		if size(PickedNodeCache_,1)<2
			[~,tarNodes] =  min(vecnorm(PickedNodeCache_-ndC,2,2));
			iLth = 1;
		else
			ctr = PickedNodeCache_(end-1,:);
			rangeLimitNode = PickedNodeCache_(end,:);
			effectRad = norm(rangeLimitNode-ctr);
			tarNodes = find(vecnorm(ctr-ndC,2,2)<=effectRad);
			iLth = length(tarNodes);
		end
	else
		ctr = PickedNodeCache_(end,:);
		effectRad = varargin{1};
		tarNodes = find(vecnorm(ctr-ndC,2,2)<=effectRad);
		iLth = length(tarNodes);
	end
	fixingCond_(end+1:end+iLth,1) = meshHierarchy_(1).nodesOnBoundary(tarNodes);
	fixingCond_ = unique(fixingCond_);
	tarNodeCoord = ndC(tarNodes,:);	
	hold on; plot3(tarNodeCoord(:,1), tarNodeCoord(:,2), ...
				tarNodeCoord(:,3), 'xk', 'LineWidth', 2, 'MarkerSize', 6);
end