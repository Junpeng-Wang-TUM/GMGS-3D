function gridOUTPUT = Voxelize(gridX,gridY,gridZ,meshXYZ)
	% Copyright (c) 2013, Adam H. Aitkenhead
	% All rights reserved.
	
	% Redistribution and use in source and binary forms, with or without
	% modification, are permitted provided that the following conditions are
	% met:
	
	%     * Redistributions of source code must retain the above copyright
	%       notice, this list of conditions and the following disclaimer.
	%     * Redistributions in binary form must reproduce the above copyright
	%       notice, this list of conditions and the following disclaimer in
	%       the documentation and/or other materials provided with the distribution
	%     * Neither the name of the The Christie NHS Foundation Trust nor the names
	%       of its contributors may be used to endorse or promote products derived
	%       from this software without specific prior written permission.
	
	% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
	% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	% POSSIBILITY OF SUCH DAMAGE.

	% VOXELISE  Voxelise a 3D triangular-polygon mesh.
	% AUTHOR        Adam H. Aitkenhead
	% CONTACT       adam.aitkenhead@christie.nhs.uk
	% INSTITUTION   The Christie NHS Foundation Trust
	raydirection = 'xyz';
	
	%======================================================
	% IDENTIFY THE MIN AND MAX X,Y,Z COORDINATES OF THE POLYGON MESH
	%======================================================	
	meshXmin = min(min(meshXYZ(:,1,:)));
	meshXmax = max(max(meshXYZ(:,1,:)));
	meshYmin = min(min(meshXYZ(:,2,:)));
	meshYmax = max(max(meshXYZ(:,2,:)));
	meshZmin = min(min(meshXYZ(:,3,:)));
	meshZmax = max(max(meshXYZ(:,3,:)));	

	%======================================================
	% define the coordinates with gridCOx, gridCOy, gridCOz
	%======================================================	
	voxwidth  = (meshXmax-meshXmin)/(gridX+1/2);
	gridCOx   = meshXmin+voxwidth/2 : voxwidth : meshXmax-voxwidth/2;
	voxwidth  = (meshYmax-meshYmin)/(gridY+1/2);
	gridCOy   = meshYmin+voxwidth/2 : voxwidth : meshYmax-voxwidth/2;
	voxwidth  = (meshZmax-meshZmin)/(gridZ+1/2);
	gridCOz   = meshZmin+voxwidth/2 : voxwidth : meshZmax-voxwidth/2; 
	
	%======================================================
	% VOXELISE USING THE USER DEFINED RAY DIRECTION(S)
	%======================================================
	
	%Count the number of voxels in each direction:
	voxcountX = numel(gridCOx);
	voxcountY = numel(gridCOy);
	voxcountZ = numel(gridCOz);
	
	% Prepare logical array to hold the voxelised data:
	gridOUTPUT = false(voxcountX,voxcountY,voxcountZ,numel(raydirection));
	countdirections = 0;
	if strfind(raydirection,'x')
		countdirections = countdirections + 1;
		gridOUTPUT(:,:,:,countdirections) = ...
			permute( VOXELISEinternal(gridCOy,gridCOz,gridCOx,meshXYZ(:,[2,3,1],:)) ,[3,1,2] );
	end
	
	if strfind(raydirection,'y')
		countdirections = countdirections + 1;
		gridOUTPUT(:,:,:,countdirections) = ...
			permute( VOXELISEinternal(gridCOz,gridCOx,gridCOy,meshXYZ(:,[3,1,2],:)) ,[2,3,1] );
	end
	
	if strfind(raydirection,'z')
		countdirections = countdirections + 1;
		gridOUTPUT(:,:,:,countdirections) = ...
			VOXELISEinternal(gridCOx,gridCOy,gridCOz,meshXYZ);
	end
	
	% Combine the results of each ray-tracing direction:
	if numel(raydirection)>1
		gridOUTPUT = sum(gridOUTPUT,4)>=numel(raydirection)/2;
	end
	
	gridOUTPUT = permute(gridOUTPUT, [2 1 3]); %to adapt the discretizinh alg.
end

%==========================================================================
function [gridOUTPUT] = VOXELISEinternal(gridCOx,gridCOy,gridCOz,meshXYZ)

	%Count the number of voxels in each direction:
	voxcountX = numel(gridCOx);
	voxcountY = numel(gridCOy);
	voxcountZ = numel(gridCOz);
	
	% Prepare logical array to hold the voxelised data:
	gridOUTPUT = false(voxcountX,voxcountY,voxcountZ);
	
	%Identify the min and max x,y coordinates (cm) of the mesh:
	meshXmin = min(min(meshXYZ(:,1,:)));
	meshXmax = max(max(meshXYZ(:,1,:)));
	meshYmin = min(min(meshXYZ(:,2,:)));
	meshYmax = max(max(meshXYZ(:,2,:)));
	meshZmin = min(min(meshXYZ(:,3,:)));
	meshZmax = max(max(meshXYZ(:,3,:)));
	
	%Identify the min and max x,y coordinates (pixels) of the mesh:
	meshXminp = find(abs(gridCOx-meshXmin)==min(abs(gridCOx-meshXmin)));
	meshXmaxp = find(abs(gridCOx-meshXmax)==min(abs(gridCOx-meshXmax)));
	meshYminp = find(abs(gridCOy-meshYmin)==min(abs(gridCOy-meshYmin)));
	meshYmaxp = find(abs(gridCOy-meshYmax)==min(abs(gridCOy-meshYmax)));

	%Make sure min < max for the mesh coordinates:
	if meshXminp > meshXmaxp
	[meshXminp,meshXmaxp] = deal(meshXmaxp,meshXminp);
	end %if
	if meshYminp > meshYmaxp
	[meshYminp,meshYmaxp] = deal(meshYmaxp,meshYminp);
	end %if
	
	%Identify the min and max x,y,z coordinates of each facet:
	meshXYZmin = min(meshXYZ,[],3);
	meshXYZmax = max(meshXYZ,[],3);


	%======================================================
	% VOXELISE THE MESH
	%======================================================
	
	correctionLIST = [];   %Prepare to record all rays that fail the voxelisation.  This array is built on-the-fly, but since
						%it ought to be relatively small should not incur too much of a speed penalty.
						
	% Loop through each x,y pixel.
	% The mesh will be voxelised by passing rays in the z-direction through
	% each x,y pixel, and finding the locations where the rays cross the mesh.
	for loopY = meshYminp:meshYmaxp
		% - 1a - Find which mesh facets could possibly be crossed by the ray:
		possibleCROSSLISTy = find( meshXYZmin(:,2)<=gridCOy(loopY) & meshXYZmax(:,2)>=gridCOy(loopY) );
	
		for loopX = meshXminp:meshXmaxp    
			% - 1b - Find which mesh facets could possibly be crossed by the ray:
			possibleCROSSLIST = possibleCROSSLISTy( meshXYZmin(possibleCROSSLISTy,1)<=gridCOx(loopX) & ...
				meshXYZmax(possibleCROSSLISTy,1)>=gridCOx(loopX) );
			if isempty(possibleCROSSLIST)==0  %Only continue the analysis if some nearby facets were actually identified          
				% - 2 - For each facet, check if the ray really does cross the facet rather than just passing it close-by:
					
				% GENERAL METHOD:
				% A. Take each edge of the facet in turn.
				% B. Find the position of the opposing vertex to that edge.
				% C. Find the position of the ray relative to that edge.
				% D. Check if ray is on the same side of the edge as the opposing vertex.
				% E. If this is true for all three edges, then the ray definitely passes through the facet.
				%
				% NOTES:
				% A. If a ray crosses exactly on a vertex:
				%    a. If the surrounding facets have normal components pointing in the same (or opposite) direction as the ray then the face IS crossed.
				%    b. Otherwise, add the ray to the correctionlist.
				
				facetCROSSLIST = [];   %Prepare to record all facets which are crossed by the ray.  This array is built on-the-fly, but since
										%it ought to be relatively small (typically a list of <10) should not incur too much of a speed penalty.
				
				%----------
				% - 1 - Check for crossed vertices:
				%----------
				
				% Find which mesh facets contain a vertex which is crossed by the ray:
				vertexCROSSLIST = possibleCROSSLIST( (meshXYZ(possibleCROSSLIST,1,1)==gridCOx(loopX) & meshXYZ(possibleCROSSLIST,2,1)==gridCOy(loopY)) ...
											| (meshXYZ(possibleCROSSLIST,1,2)==gridCOx(loopX) & meshXYZ(possibleCROSSLIST,2,2)==gridCOy(loopY)) ...
											| (meshXYZ(possibleCROSSLIST,1,3)==gridCOx(loopX) & meshXYZ(possibleCROSSLIST,2,3)==gridCOy(loopY)) ...
											);
		
				if isempty(vertexCROSSLIST)==0  %Only continue the analysis if potential vertices were actually identified
					checkindex = zeros(1,numel(vertexCROSSLIST));
						while min(checkindex) == 0         
						vertexindex             = find(checkindex==0,1,'first');
						checkindex(vertexindex) = 1;
						
						[temp.faces,temp.vertices] = CONVERT_meshformat(meshXYZ(vertexCROSSLIST,:,:));
						adjacentindex              = ismember(temp.faces,temp.faces(vertexindex,:));
						adjacentindex              = max(adjacentindex,[],2);
						checkindex(adjacentindex)  = 1;
						
						coN = COMPUTE_mesh_normals(meshXYZ(vertexCROSSLIST(adjacentindex),:,:));
						
						if max(coN(:,3))<0 || min(coN(:,3))>0
							facetCROSSLIST    = [facetCROSSLIST,vertexCROSSLIST(vertexindex)];
						else
							possibleCROSSLIST = [];
							correctionLIST    = [ correctionLIST; loopX,loopY ];
							checkindex(:)     = 1;
						end				
					end       
				end
      
				%----------
				% - 2 - Check for crossed facets:
				%----------
				
				if isempty(possibleCROSSLIST)==0  %Only continue the analysis if some nearby facets were actually identified
				
					for loopCHECKFACET = possibleCROSSLIST'
			
						%Check if ray crosses the facet.  This method is much (>>10 times) faster than using the built-in function 'inpolygon'.
						%Taking each edge of the facet in turn, check if the ray is on the same side as the opposing vertex.
						
						Y1predicted = meshXYZ(loopCHECKFACET,2,2) - ((meshXYZ(loopCHECKFACET,2,2)-meshXYZ(loopCHECKFACET,2,3)) * (meshXYZ(loopCHECKFACET,1,2)-meshXYZ(loopCHECKFACET,1,1))/(meshXYZ(loopCHECKFACET,1,2)-meshXYZ(loopCHECKFACET,1,3)));
						YRpredicted = meshXYZ(loopCHECKFACET,2,2) - ((meshXYZ(loopCHECKFACET,2,2)-meshXYZ(loopCHECKFACET,2,3)) * (meshXYZ(loopCHECKFACET,1,2)-gridCOx(loopX))/(meshXYZ(loopCHECKFACET,1,2)-meshXYZ(loopCHECKFACET,1,3)));
						
						if (Y1predicted > meshXYZ(loopCHECKFACET,2,1) && YRpredicted > gridCOy(loopY)) || (Y1predicted < meshXYZ(loopCHECKFACET,2,1) && YRpredicted < gridCOy(loopY))
							%The ray is on the same side of the 2-3 edge as the 1st vertex.
				
							Y2predicted = meshXYZ(loopCHECKFACET,2,3) - ((meshXYZ(loopCHECKFACET,2,3)-meshXYZ(loopCHECKFACET,2,1)) * (meshXYZ(loopCHECKFACET,1,3)-meshXYZ(loopCHECKFACET,1,2))/(meshXYZ(loopCHECKFACET,1,3)-meshXYZ(loopCHECKFACET,1,1)));
							YRpredicted = meshXYZ(loopCHECKFACET,2,3) - ((meshXYZ(loopCHECKFACET,2,3)-meshXYZ(loopCHECKFACET,2,1)) * (meshXYZ(loopCHECKFACET,1,3)-gridCOx(loopX))/(meshXYZ(loopCHECKFACET,1,3)-meshXYZ(loopCHECKFACET,1,1)));
						
							if (Y2predicted > meshXYZ(loopCHECKFACET,2,2) && YRpredicted > gridCOy(loopY)) || (Y2predicted < meshXYZ(loopCHECKFACET,2,2) && YRpredicted < gridCOy(loopY))
								%The ray is on the same side of the 3-1 edge as the 2nd vertex.
					
								Y3predicted = meshXYZ(loopCHECKFACET,2,1) - ((meshXYZ(loopCHECKFACET,2,1)-meshXYZ(loopCHECKFACET,2,2)) * (meshXYZ(loopCHECKFACET,1,1)-meshXYZ(loopCHECKFACET,1,3))/(meshXYZ(loopCHECKFACET,1,1)-meshXYZ(loopCHECKFACET,1,2)));
								YRpredicted = meshXYZ(loopCHECKFACET,2,1) - ((meshXYZ(loopCHECKFACET,2,1)-meshXYZ(loopCHECKFACET,2,2)) * (meshXYZ(loopCHECKFACET,1,1)-gridCOx(loopX))/(meshXYZ(loopCHECKFACET,1,1)-meshXYZ(loopCHECKFACET,1,2)));
						
								if (Y3predicted > meshXYZ(loopCHECKFACET,2,3) && YRpredicted > gridCOy(loopY)) || (Y3predicted < meshXYZ(loopCHECKFACET,2,3) && YRpredicted < gridCOy(loopY))
									%The ray is on the same side of the 1-2 edge as the 3rd vertex.
					
									%The ray passes through the facet since it is on the correct side of all 3 edges
									facetCROSSLIST = [facetCROSSLIST,loopCHECKFACET];						
								end %if
							end %if
						end %if				
					end %for
    

					%----------
					% - 3 - Find the z coordinate of the locations where the ray crosses each facet or vertex:
					%----------
			
					gridCOzCROSS = zeros(size(facetCROSSLIST));
					for loopFINDZ = facetCROSSLIST
						% METHOD:
						% 1. Define the equation describing the plane of the facet.  For a
						% more detailed outline of the maths, see:
						% http://local.wasp.uwa.edu.au/~pbourke/geometry/planeeq/
						%    Ax + By + Cz + D = 0
						%    where  A = y1 (z2 - z3) + y2 (z3 - z1) + y3 (z1 - z2)
						%           B = z1 (x2 - x3) + z2 (x3 - x1) + z3 (x1 - x2)
						%           C = x1 (y2 - y3) + x2 (y3 - y1) + x3 (y1 - y2)
						%           D = - x1 (y2 z3 - y3 z2) - x2 (y3 z1 - y1 z3) - x3 (y1 z2 - y2 z1)
						% 2. For the x and y coordinates of the ray, solve these equations to find the z coordinate in this plane.
				
						planecoA = meshXYZ(loopFINDZ,2,1)*(meshXYZ(loopFINDZ,3,2)-meshXYZ(loopFINDZ,3,3)) + meshXYZ(loopFINDZ,2,2)*(meshXYZ(loopFINDZ,3,3)-meshXYZ(loopFINDZ,3,1)) + meshXYZ(loopFINDZ,2,3)*(meshXYZ(loopFINDZ,3,1)-meshXYZ(loopFINDZ,3,2));
						planecoB = meshXYZ(loopFINDZ,3,1)*(meshXYZ(loopFINDZ,1,2)-meshXYZ(loopFINDZ,1,3)) + meshXYZ(loopFINDZ,3,2)*(meshXYZ(loopFINDZ,1,3)-meshXYZ(loopFINDZ,1,1)) + meshXYZ(loopFINDZ,3,3)*(meshXYZ(loopFINDZ,1,1)-meshXYZ(loopFINDZ,1,2)); 
						planecoC = meshXYZ(loopFINDZ,1,1)*(meshXYZ(loopFINDZ,2,2)-meshXYZ(loopFINDZ,2,3)) + meshXYZ(loopFINDZ,1,2)*(meshXYZ(loopFINDZ,2,3)-meshXYZ(loopFINDZ,2,1)) + meshXYZ(loopFINDZ,1,3)*(meshXYZ(loopFINDZ,2,1)-meshXYZ(loopFINDZ,2,2));
						planecoD = - meshXYZ(loopFINDZ,1,1)*(meshXYZ(loopFINDZ,2,2)*meshXYZ(loopFINDZ,3,3)-meshXYZ(loopFINDZ,2,3)*meshXYZ(loopFINDZ,3,2)) - meshXYZ(loopFINDZ,1,2)*(meshXYZ(loopFINDZ,2,3)*meshXYZ(loopFINDZ,3,1)-meshXYZ(loopFINDZ,2,1)*meshXYZ(loopFINDZ,3,3)) - meshXYZ(loopFINDZ,1,3)*(meshXYZ(loopFINDZ,2,1)*meshXYZ(loopFINDZ,3,2)-meshXYZ(loopFINDZ,2,2)*meshXYZ(loopFINDZ,3,1));
				
						if abs(planecoC) < 1e-14
							planecoC=0;
						end
					
						gridCOzCROSS(facetCROSSLIST==loopFINDZ) = (- planecoD - planecoA*gridCOx(loopX) - planecoB*gridCOy(loopY)) / planecoC;
					
					end %for

					%Remove values of gridCOzCROSS which are outside of the mesh limits (including a 1e-12 margin for error).
					gridCOzCROSS = gridCOzCROSS( gridCOzCROSS>=meshZmin-1e-12 & gridCOzCROSS<=meshZmax+1e-12 );
				
					%Round gridCOzCROSS to remove any rounding errors, and take only the unique values:
					gridCOzCROSS = round(gridCOzCROSS*1e12)/1e12;
					gridCOzCROSS = unique(gridCOzCROSS);
				
					%----------
					% - 4 - Label as being inside the mesh all the voxels that the ray passes through after crossing one facet before crossing another facet:
					%----------
			
					if rem(numel(gridCOzCROSS),2)==0  % Only rays which cross an even number of facets are voxelised
						for loopASSIGN = 1:(numel(gridCOzCROSS)/2)
							voxelsINSIDE = (gridCOz>gridCOzCROSS(2*loopASSIGN-1) & gridCOz<gridCOzCROSS(2*loopASSIGN));
							gridOUTPUT(loopX,loopY,voxelsINSIDE) = 1;
						end %for       
					elseif numel(gridCOzCROSS)~=0    % Remaining rays which meet the mesh in some way are not voxelised, but are labelled for correction later.         
						correctionLIST = [ correctionLIST; loopX,loopY ];       
					end %if
				end      
			end %if
		end %for
	end %for
	
	%======================================================
	% USE INTERPOLATION TO FILL IN THE RAYS WHICH COULD NOT BE VOXELISED
	%======================================================
	%For rays where the voxelisation did not give a clear result, the ray is
	%computed by interpolating from the surrounding rays.
	countCORRECTIONLIST = size(correctionLIST,1);

	if countCORRECTIONLIST>0		
		%If necessary, add a one-pixel border around the x and y edges of the
		%array.  This prevents an error if the code tries to interpolate a ray at
		%the edge of the x,y grid.
		if min(correctionLIST(:,1))==1 || max(correctionLIST(:,1))==numel(gridCOx) || min(correctionLIST(:,2))==1 || max(correctionLIST(:,2))==numel(gridCOy)
			gridOUTPUT     = [zeros(1,voxcountY+2,voxcountZ);zeros(voxcountX,1,voxcountZ),gridOUTPUT,zeros(voxcountX,1,voxcountZ);zeros(1,voxcountY+2,voxcountZ)];
			correctionLIST = correctionLIST + 1;
		end
		
		for loopC = 1:countCORRECTIONLIST
			voxelsforcorrection = squeeze( sum( [ gridOUTPUT(correctionLIST(loopC,1)-1,correctionLIST(loopC,2)-1,:) ,...
												gridOUTPUT(correctionLIST(loopC,1)-1,correctionLIST(loopC,2),:)   ,...
												gridOUTPUT(correctionLIST(loopC,1)-1,correctionLIST(loopC,2)+1,:) ,...
												gridOUTPUT(correctionLIST(loopC,1),correctionLIST(loopC,2)-1,:)   ,...
												gridOUTPUT(correctionLIST(loopC,1),correctionLIST(loopC,2)+1,:)   ,...
												gridOUTPUT(correctionLIST(loopC,1)+1,correctionLIST(loopC,2)-1,:) ,...
												gridOUTPUT(correctionLIST(loopC,1)+1,correctionLIST(loopC,2),:)   ,...
												gridOUTPUT(correctionLIST(loopC,1)+1,correctionLIST(loopC,2)+1,:) ,...
												] ) );
			voxelsforcorrection = (voxelsforcorrection>=4);
			gridOUTPUT(correctionLIST(loopC,1),correctionLIST(loopC,2),voxelsforcorrection) = 1;
		end %for
	
		%Remove the one-pixel border surrounding the array, if this was added
		%previously.
		if size(gridOUTPUT,1)>numel(gridCOx) || size(gridOUTPUT,2)>numel(gridCOy)
			gridOUTPUT = gridOUTPUT(2:end-1,2:end-1,:);
		end		
	end %if	
	%disp([' Ray tracing result: ',num2str(countCORRECTIONLIST),' rays (',num2str(countCORRECTIONLIST/(voxcountX*voxcountY)*100,'%5.1f'),'% of all rays) exactly crossed a facet edge and had to be computed by interpolation.'])

end %function


function [coordNORMALS,varargout] = COMPUTE_mesh_normals(meshdataIN,invertYN)
	% COMPUTE_mesh_normals  Calculate the normals for each facet of a triangular mesh
	%==========================================================================
	% AUTHOR        Adam H. Aitkenhead
	% CONTACT       adam.aitkenhead@physics.cr.man.ac.uk
	% INSTITUTION   The Christie NHS Foundation Trust
	% DATE          March 2010
	% PURPOSE       Calculate the normal vectors for each facet of a triangular
	%               mesh.  The ordering of the vertices
	%               (clockwise/anticlockwise) is also checked for all facets if
	%               this is requested as one of the outputs.
	%
	% USAGE         [coordNORMALS] = COMPUTE_mesh_normals(meshdataIN)
	%       ..or..  [coordNORMALS,meshdataOUT] = COMPUTE_mesh_normals(meshdataIN,invertYN)
	%
	% INPUTS
	%
	%    meshdataIN   - (structure)  Structure containing the faces and
	%                   vertices of the mesh, in the same format as that
	%                   produced by the isosurface command.
	%         ..or..  - (Nx3x3 array)  The vertex coordinates for each facet,
	%                   with:  1 row for each facet
	%                          3 columns for the x,y,z coordinates
	%                          3 pages for the three vertices
	%    invertYN     - (optional)  A flag to say whether the mesh is to be
	%                   inverted or not.  Should be 'y' or 'n'.
	%
	% OUTPUTS
	%
	%    coordNORMALS - Nx3 array   - The normal vectors for each facet, with:
	%                          1 row for each facet
	%                          3 columns for the x,y,z components
	%
	%    meshdataOUT  - (optional)  - The mesh data with the ordering of the
	%                   vertices (clockwise/anticlockwise) checked.  Uses the
	%                   same format as <meshdataIN>.
	%
	% NOTES       - Computing <meshdataOUT> to check the ordering of the
	%               vertices in each facet may be slow for large meshes.
	%             - It may not be possible to compute <meshdataOUT> for
	%               non-manifold meshes.
	%==========================================================================
	
	%==========================================================================
	% VERSION  USER  CHANGES
	% -------  ----  -------
	% 100331   AHA   Original version
	% 101129   AHA   Can now check the ordering of the facet vertices.
	% 101130   AHA   <meshdataIN> can now be in either of two formats.
	% 101201   AHA   Only check the vertex ordering if that is required as one
	%                of the outputs, as it can be slow for large meshes.
	% 101201   AHA   Add the flag invertYN and make it possible to invert the
	%                mesh
	% 111004   AHA   Housekeeping tidy-up
	%==========================================================================
	
	%======================================================
	% Read the input parameters
	%======================================================

	if isstruct(meshdataIN)==1
		faces         = meshdataIN.faces;
		vertex        = meshdataIN.vertices;
		coordVERTICES = zeros(size(faces,1),3,3);
		for loopa = 1:size(faces,1)
			coordVERTICES(loopa,:,1) = vertex(faces(loopa,1),:);
			coordVERTICES(loopa,:,2) = vertex(faces(loopa,2),:);
			coordVERTICES(loopa,:,3) = vertex(faces(loopa,3),:);
		end
	else
		coordVERTICES = meshdataIN;
	end

	%======================================================
	% Invert the mesh if required
	%======================================================

	if exist('invertYN','var')==1 && isempty(invertYN)==0 && ischar(invertYN)==1 && ( strncmpi(invertYN,'y',1)==1 || strncmpi(invertYN,'i',1)==1 )
		coV           = zeros(size(coordVERTICES));
		coV(:,:,1)    = coordVERTICES(:,:,1);
		coV(:,:,2)    = coordVERTICES(:,:,3);
		coV(:,:,3)    = coordVERTICES(:,:,2);
		coordVERTICES = coV;
	end

	%======================
	% Initialise array to hold the normal vectors
	%======================
	
	facetCOUNT   = size(coordVERTICES,1);
	coordNORMALS = zeros(facetCOUNT,3);
	
	%======================
	% Check the vertex ordering for each facet
	%======================

	if nargout==2
		startfacet  = 1;
		edgepointA  = 1;
		checkedlist = false(facetCOUNT,1);
		waitinglist = false(facetCOUNT,1);
		
		while min(checkedlist)==0
    
			checkedlist(startfacet) = 1;
		
			edgepointB = edgepointA + 1;
			if edgepointB==4
			edgepointB = 1;
			end
    
			%Find points which match edgepointA
			sameX = coordVERTICES(:,1,:)==coordVERTICES(startfacet,1,edgepointA);
			sameY = coordVERTICES(:,2,:)==coordVERTICES(startfacet,2,edgepointA);
			sameZ = coordVERTICES(:,3,:)==coordVERTICES(startfacet,3,edgepointA);
			[tempa,tempb] = find(sameX & sameY & sameZ);
			matchpointA = [tempa,tempb];
			matchpointA = matchpointA(matchpointA(:,1)~=startfacet,:);
  
			%Find points which match edgepointB
			sameX = coordVERTICES(:,1,:)==coordVERTICES(startfacet,1,edgepointB);
			sameY = coordVERTICES(:,2,:)==coordVERTICES(startfacet,2,edgepointB);
			sameZ = coordVERTICES(:,3,:)==coordVERTICES(startfacet,3,edgepointB);
			[tempa,tempb] = find(sameX & sameY & sameZ);
			matchpointB = [tempa,tempb];
			matchpointB = matchpointB(matchpointB(:,1)~=startfacet,:);
  
			%Find edges which match both edgepointA and edgepointB -> giving the adjacent edge
			[memberA,memberB] = ismember(matchpointA(:,1),matchpointB(:,1));
			matchfacet = matchpointA(memberA,1);
  
			if numel(matchfacet)~=1
				if exist('warningdone','var')==0
					warning('Mesh is non-manifold.')
					warningdone = 1;
				end
			else
				matchpointA = matchpointA(memberA,2);
				matchpointB = matchpointB(memberB(memberA),2);
			
				if checkedlist(matchfacet)==0 && waitinglist(matchfacet)==0
					%Ensure the adjacent edge is traveled in the opposite direction to the original edge  
					if matchpointB-matchpointA==1 || matchpointB-matchpointA==-2
						%Direction needs to be flipped
						[ coordVERTICES(matchfacet,:,matchpointA) , coordVERTICES(matchfacet,:,matchpointB) ] = deal( coordVERTICES(matchfacet,:,matchpointB) , coordVERTICES(matchfacet,:,matchpointA) );
					end
				end
			end
  
			waitinglist(matchfacet) = 1;
    
			if edgepointA<3
				edgepointA = edgepointA + 1;
			elseif edgepointA==3
				edgepointA = 1;
				checkedlist(startfacet) = 1;
				startfacet = find(waitinglist==1 & checkedlist==0,1,'first');
			end
  
		end
	end

	%======================
	% Compute the normal vector for each facet
	%======================
	
	for loopFACE = 1:facetCOUNT
	
		%Find the coordinates for each vertex.
		cornerA = coordVERTICES(loopFACE,1:3,1);
		cornerB = coordVERTICES(loopFACE,1:3,2);
		cornerC = coordVERTICES(loopFACE,1:3,3);
		
		%Compute the vectors AB and AC
		AB = cornerB-cornerA;
		AC = cornerC-cornerA;
			
		%Determine the cross product AB x AC
		ABxAC = cross(AB,AC);
			
		%Normalise to give a unit vector
		ABxAC = ABxAC / norm(ABxAC);
		coordNORMALS(loopFACE,1:3) = ABxAC;
	
	end %loopFACE

	%======================================================
	% Prepare the output parameters
	%======================================================
	
	if nargout==2
		if isstruct(meshdataIN)==1
			[faces,vertices] = CONVERT_meshformat(coordVERTICES);
			meshdataOUT = struct('vertices',vertices,'faces',faces);
		else
			meshdataOUT = coordVERTICES;
		end
		varargout(1) = {meshdataOUT};
	end
%======================================================
end %function


