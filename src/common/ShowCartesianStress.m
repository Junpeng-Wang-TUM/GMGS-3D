function ShowCartesianStress(sType, varargin)
	global cartesianStressField_;
	if isempty(cartesianStressField_)
		warning('No Stress Field Available! Please Compute Stress First by running FUNCTION GetCartesianStress!'); return; 
	end
	switch sType
		case 'Sigma_xx'
			srcField = cartesianStressField_(:,1);
		case 'Sigma_yy'
			srcField = cartesianStressField_(:,2);
		case 'Sigma_zz'
			srcField = cartesianStressField_(:,3);
		case 'Sigma_yz'
			srcField = cartesianStressField_(:,4);
		case 'Sigma_zx'
			srcField = cartesianStressField_(:,5);
		case 'Sigma_xy'
			srcField = cartesianStressField_(:,6);			
		otherwise
			warning('Undefined Stress Type!'); return;				
	end
	if 1==nargin
		VisScalarField(srcField);
	else
		VisScalarField(srcField, varargin{1});
	end	
end