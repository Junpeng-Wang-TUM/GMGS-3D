function ShowDeformation(dir, varargin)
	global U_;
	if isempty(U_)
		warning('No Deformation Field Available! Please Compute Deformation First by running FUNCTION GetDeformation!'); return; 
	end
	switch dir
		case 'X'
			srcField = U_(1:3:end,1);
		case 'Y'
			srcField = U_(2:3:end,1);
		case 'Z'
			srcField = U_(3:3:end,1);
		case 'T'
			srcField = vecnorm(reshape(U_, 3, numel(U_)/3)',2,2);
		otherwise
			warning('Undefined Deformation Direction!'); return;				
	end
	if 1==nargin
		VisScalarField(srcField);
	else
		VisScalarField(srcField, varargin{1});
	end	
end