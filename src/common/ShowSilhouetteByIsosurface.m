function hd = ShowSilhouetteByIsosurface(iMesh)
	global boundingBox_;
	global nodeCoords_
	nx = iMesh.resX;
	ny = iMesh.resY;
	nz = iMesh.resZ;
	nodPosX = reshape(nodeCoords_(:,1), ny+1, nx+1, nz+1);
	nodPosY = reshape(nodeCoords_(:,2), ny+1, nx+1, nz+1);
	nodPosZ = reshape(nodeCoords_(:,3), ny+1, nx+1, nz+1);
	valForExtctBoundary = zeros((nx+1)*(ny+1)*(nz+1),1);					
	valForExtctBoundary(find(0~=iMesh.nodMapForward)) = 1;
	valForExtctBoundary = reshape(valForExtctBoundary, ny+1, nx+1, nz+1);
	hd(1) = patch(isosurface(nodPosX, nodPosY, nodPosZ, valForExtctBoundary, 0)); hold('on')
	hd(2) = patch(isocaps(nodPosX, nodPosY, nodPosZ, valForExtctBoundary, 0));	
	camproj('perspective');
	set(hd, 'FaceColor', [65 174 118]/255, 'FaceAlpha', 1.0, 'EdgeColor', 'None');
	axis('off'); axis('equal'); axis('tight');
	[az, el] = view(3); 
	lighting('gouraud');
	camlight(az,el,'infinite');
	camlight('headlight','infinite');
	material('dull');
end