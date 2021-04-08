function dShape = DeShapeFunction(varargin)	
	s = varargin{1}; t = varargin{2}; p = varargin{3};
	dN1ds = -0.125*(1-t).*(1-p); dN2ds = 0.125*(1-t).*(1-p); 
	dN3ds = 0.125*(1+t).*(1-p);  dN4ds = -0.125*(1+t).*(1-p);
	dN5ds = -0.125*(1-t).*(1+p); dN6ds = 0.125*(1-t).*(1+p); 
	dN7ds = 0.125*(1+t).*(1+p);  dN8ds = -0.125*(1+t).*(1+p);
	
	dN1dt = -0.125*(1-s).*(1-p); dN2dt = -0.125*(1+s).*(1-p); 
	dN3dt = 0.125*(1+s).*(1-p);  dN4dt = 0.125*(1-s).*(1-p);
	dN5dt = -0.125*(1-s).*(1+p); dN6dt = -0.125*(1+s).*(1+p); 
	dN7dt = 0.125*(1+s).*(1+p);  dN8dt = 0.125*(1-s).*(1+p);
	
	dN1dp = -0.125*(1-s).*(1-t); dN2dp = -0.125*(1+s).*(1-t); 
	dN3dp = -0.125*(1+s).*(1+t); dN4dp = -0.125*(1-s).*(1+t);
	dN5dp = 0.125*(1-s).*(1-t);  dN6dp = 0.125*(1+s).*(1-t); 
	dN7dp = 0.125*(1+s).*(1+t);  dN8dp = 0.125*(1-s).*(1+t);
	
	numCoord = length(s);
	dShape = zeros(3*numCoord, 8);
	dShape(1:3:end,:) = [dN1ds dN2ds dN3ds dN4ds dN5ds dN6ds dN7ds dN8ds];
	dShape(2:3:end,:) = [dN1dt dN2dt dN3dt dN4dt dN5dt dN6dt dN7dt dN8dt];
	dShape(3:3:end,:) = [dN1dp dN2dp dN3dp dN4dp dN5dp dN6dp dN7dp dN8dp];
end