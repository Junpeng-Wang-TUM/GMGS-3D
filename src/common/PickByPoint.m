function PickByPoint(varargin)
	%% Syntax: 
	%% PickByPoint(); 
	%% PickByLine(handInputCoordinate); 
	global boundaryNodeCoords_;
	global PickedNodeCache_;
	global hdPickedNode_;
	if 0==nargin
		dcm_obj = datacursormode;
		info_struct = getCursorInfo(dcm_obj);
		if isempty(info_struct)
			warning('No Cursor Mode Available!'); return;
		end
		tarNode = info_struct.Position;
	elseif 1==nargin
		tarNode = varargin{1}; tarNode = tarNode(:)';
		if ~(3==length(tarNode)), warning('Wrong Input!'); return; end
	else
		error('Wrong Input!');		
	end
	hold on; 
	hdPickedNode_(end+1) = plot3(tarNode(1), tarNode(2), tarNode(3), 'xr', 'LineWidth', 2, 'MarkerSize', 10);
	[~,newlyPickedNode] = min(vecnorm(tarNode-boundaryNodeCoords_,2,2));	
	PickedNodeCache_(end+1,1) = newlyPickedNode;
end