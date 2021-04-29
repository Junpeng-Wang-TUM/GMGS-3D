function InitializeFixingCond()
	global meshHierarchy_;	
	global fixingCond_;
	global PickedNodeCache_;
	if isempty(PickedNodeCache_), warning('There is no node available!'); return; end
	PickedNodeCache_ = unique(PickedNodeCache_);
	numTarNodes = length(PickedNodeCache_);

	iFixingVec = meshHierarchy_(1).nodesOnBoundary(PickedNodeCache_,1);
	fixingCond_(end+1:end+numTarNodes,1) = iFixingVec;
	
	ClearPickedNodes();
	ShowFixingCondition(iFixingVec);				
end