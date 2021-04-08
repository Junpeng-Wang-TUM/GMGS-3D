function InitializeLoadingCond(force, varargin)
	global meshHierarchy_;
	global nodeCoords_;
	global loadingCond_;
	global PickedNodeCache_;
	ndC = nodeCoords_(meshHierarchy_(1).solidNodesMapVec(meshHierarchy_(1).nodesOnBoundary),:);
	if isempty(PickedNodeCache_), warning('There is no node selected!'); end
	
	if 1==nargin
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
	
	numTarNodes = length(tarNodes);
	iLoadingVec = [double(meshHierarchy_(1).nodesOnBoundary(tarNodes)) repmat(force, numTarNodes, 1)];
	loadingCond_(end+1:end+iLth,1:4) = iLoadingVec;
	
	global domainUpperBound_; global domainLowerBound_;
	tarNodeCoord = ndC(tarNodes,:);	
	amplitudesF = mean(domainUpperBound_-domainLowerBound_)/5* ...
		iLoadingVec(:,2:4)./vecnorm(iLoadingVec(:,2:4), 2, 2);
	hold on; quiver3(tarNodeCoord(:,1), tarNodeCoord(:,2), ...
		tarNodeCoord(:,3), amplitudesF(:,1), amplitudesF(:,2), amplitudesF(:,3), ...
			0, 'Color', [1.0 0.0 0.0], 'LineWidth', 2, 'MaxHeadSize', 1, 'MaxHeadSize', 1); 	
end