function deltaU = Vcycle(r)	
	global meshHierarchy_;
	global numLevels_;
	global cholFac_; global cholPermut_;
	
	%%0. preparation
	varVcycle = struct('x', 0, 'r', 0);
	varVcycle = repmat(varVcycle, numLevels_, 1);
	varVcycle(1).r = r;	

	%%1. downward fine -> coarse
	for ii=2:numLevels_
		%%1.1 apply for smoother (relaxing)
		[varVcycle(ii-1).x, varVcycle(ii-1).r] = JacobiSmoother(varVcycle(ii-1), ii-1);
		
		%%1.2 restrict residual
		varVcycle(ii).r = RestrictResidual(varVcycle(ii-1).r,ii);
	end	
	
	%%2. directly solving on coarsest level
	xCoarsest = zeros(meshHierarchy_(end).numDOFs,1);
	xCoarsest(meshHierarchy_(end).freeDOFs) = ...
		(cholPermut_*(cholFac_'\(cholFac_\(cholPermut_'*varVcycle(end).r(meshHierarchy_(end).freeDOFs)))));
	varVcycle(end).x = xCoarsest;
	
	%%3. upward coarse -> fine
	for ii=numLevels_:-1:2
		%%3.1. interpolation			
		varVcycle(ii-1).x = varVcycle(ii-1).x + InterpolationDeviation(varVcycle(ii).x,ii);
		
		%%3.2 apply for smoother (relaxing)
		varVcycle(ii-1).x = JacobiSmoother(varVcycle(ii-1), ii-1);
	end
	deltaU = varVcycle(1).x;
	deltaU(meshHierarchy_(1).fixedDOFs) = 0;
end



