function x = CG_solver(AtX, PtV, b, tol, maxIT_, printP)
	%%0. arguments introduction
	%%AtX --- function handle for the product of system matrix and vector
	%%b --- right hand section
	%%tol --- stopping condition: resnrm < discrepancy
	%%maxIT_ --- mAtXximum number of iterations
	global iterationHist_;
	n = length(b);
	normB = norm(b);
	its = 0;
	x = zeros(n,1);
	r1 = zeros(n,1);
	z1 = zeros(n,1);
	p2 = zeros(n,1);
	
	r1 = b - AtX(x);
	if norm(r1)/normB <= tol
		x = b; disp('The right hand side vector b is approximately 0, so x=b.'); return;
	end	
	tStart0 = tic;
	while its <= maxIT_
		var = struct('x', 0, 'r', 0); var.x = x; var.r = r1;
		[x, r1] = JacobiSmoother(var);
		
		z2 = PtV(r1);
		its = its + 1;
		if 1==its
			p2 = z2;
		else
			beta = r1'*z2/(r0'*z1);
			p2 = z2 + beta*p1;			
		end
		valMTV = AtX(p2);	
		
		alpha = r1'*z2/(p2'*valMTV);
		x = x + alpha*p2;		
		r2 = r1 - alpha*valMTV;
		
		resnorm = norm(r2)/normB;
		if strcmp(printP, 'printP_ON')
			disp([' It.: ' sprintf('%4i',its) ' Res.: ' sprintf('%16.6e',resnorm)]);
		end
		if resnorm<tol
			disp(['CG solver converged at iteration' sprintf('%5i', its) ' to a solution with relative residual' ...
					sprintf('%16.6e',resnorm)]);
			break;
		end		
		%%update
		z1 = z2;
		p1 = p2;
		r0 = r1;
		r1 = r2;
		iterationHist_(end+1,:) = [its toc(tStart0) resnorm];
	end	

	if its > maxIT_
		warning('Exceed the maximum iterate numbers');
		disp(['The iterative process stops at residual = ' sprintf('%10.4f',norm(r2))]);		
	end
end
