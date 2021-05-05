function InitializeLoadingCond(force)
	global meshHierarchy_;
	global loadingCond_;
	global PickedNodeCache_;
	
	if isempty(PickedNodeCache_), warning('There is no node selected!'); return;  end
	PickedNodeCache_ = unique(PickedNodeCache_);
	numTarNodes = length(PickedNodeCache_);
	iLoadingVec = [double(meshHierarchy_(1).nodesOnBoundary(PickedNodeCache_)) repmat(force/numTarNodes, numTarNodes, 1)];
	loadingCond_(end+1:end+numTarNodes,1:4) = iLoadingVec;	
	ClearPickedNodes();
	ShowLoadingCondition(iLoadingVec);	
end