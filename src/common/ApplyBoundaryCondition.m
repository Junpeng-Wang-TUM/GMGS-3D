function ApplyBoundaryCondition()
	global domainType_;
	global meshHierarchy_;
	global F_; 
	global loadingCond_;		
	global fixingCond_;
	F_ = sparse(meshHierarchy_(1).numNodes,3);
	if size(loadingCond_,1)>0
		F_(loadingCond_(:,1),:) = loadingCond_(:,2:4);
		F_ = reshape(F_',meshHierarchy_(1).numDOFs,1);
	end
	if length(fixingCond_)>0
		fixedDOFs = 3*int32(fixingCond_);
		fixedDOFs = [fixedDOFs-2 fixedDOFs-1 fixedDOFs];
		fixedDOFs = reshape(fixedDOFs', numel(fixedDOFs), 1);	
		freeDOFs = setdiff((1:int32(meshHierarchy_(1).numDOFs))',fixedDOFs);
		meshHierarchy_(1).fixedDOFs = fixedDOFs;
		meshHierarchy_(1).freeDOFs = freeDOFs;
	end	
end
