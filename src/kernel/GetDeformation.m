function GetDeformation()
	global meshHierarchy_;
	global F_;
	global tol_;
	global maxIT_;
	global U_;
	
	%%1. Applying For Boundary Condition
	ApplyBoundaryCondition();
	
	%%2. Initializing Solver
	if 1==length(meshHierarchy_)
		tStart = tic;
		SetupSolver();
		disp(['Initializing Solver Totally Costs : ' sprintf('%10.3g',toc(tStart)) 's']);
	end
	
	%%3. Solving
	tStart = tic;
	U_ = CG_solver(@AtX, @Vcycle, F_, tol_, maxIT_, 'printP_ON');
	disp(['Solving Linear System Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
end