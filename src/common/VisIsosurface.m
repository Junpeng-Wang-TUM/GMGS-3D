function hd = VisIsosurface(iMesh)
	global domainLowerBound_; global domainUpperBound_;	 
	nx = iMesh.resX;
	ny = iMesh.resY;
	nz = iMesh.resZ;
	[nodPosX nodPosY nodPosZ] = NodalizeDesignDomain([nx ny nz], [domainLowerBound_; domainUpperBound_], 'inGrid');
	valForExtctBoundary = zeros((nx+1)*(ny+1)*(nz+1),1);					
	valForExtctBoundary(find(0~=iMesh.solidVoidNodesLabel)) = 1;
	valForExtctBoundary = reshape(valForExtctBoundary, ny+1, nx+1, nz+1);
	hd(1) = patch(isosurface(nodPosX, nodPosY, nodPosZ, valForExtctBoundary, 0)); hold('on')
	hd(2) = patch(isocaps(nodPosX, nodPosY, nodPosZ, valForExtctBoundary, 0));	
	set(hd, 'FaceColor', [65 174 118]/255, 'FaceAlpha', 1.0, 'EdgeColor', 'None');
	axis('off'); axis('equal'); axis('tight');
	view(3); camproj('perspective');
	lighting('gouraud');
	camlight('headlight','infinite');
	camlight('right','infinite');
	camlight('left','infinite');		
end