function varargout = JacobiSmoother(var, varargin)
	global meshHierarchy_;
	global weightFactorJacobi_;
	if 1==nargin, iLayer = 1; else, iLayer = varargin{1}; end
	deltaX = weightFactorJacobi_ * var.r ./ meshHierarchy_(iLayer).diagK;
	varargout{1} = var.x + deltaX;
	if 2==nargout
		varargout{2} = var.r - AtX(deltaX, iLayer);
	end
end