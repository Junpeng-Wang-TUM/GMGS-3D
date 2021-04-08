function N = ShapeFunction(varargin)
	%				*8			*7
	%			*5			*6
	%					p
	%				   |__s (parametric coordinate system)
	%				  /-t
	%				*4			*3
	%			*1			*2
	%
	%				nodes
	s = varargin{1}; s = s(:);
	t = varargin{2}; t = t(:);
	p = varargin{3}; p = p(:);
	if ~isequal(size(s), size(t), size(p)), error('Wrong input for shape function'); end
	N = zeros(size(s,1), 8);
	N(:,1) = 0.125*(1-s).*(1-t).*(1-p);
	N(:,2) = 0.125*(1+s).*(1-t).*(1-p);
	N(:,3) = 0.125*(1+s).*(1+t).*(1-p);
	N(:,4) = 0.125*(1-s).*(1+t).*(1-p);
	N(:,5) = 0.125*(1-s).*(1-t).*(1+p);
	N(:,6) = 0.125*(1+s).*(1-t).*(1+p);
	N(:,7) = 0.125*(1+s).*(1+t).*(1+p);
	N(:,8) = 0.125*(1-s).*(1+t).*(1+p);
end