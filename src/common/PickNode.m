function PickNode()
	global PickedNodeCache_;
	global hdPickedNode_;
    dcm_obj = datacursormode;
    info_struct = getCursorInfo(dcm_obj);
    tarNode = info_struct.Position;
	numPickedNode = size(PickedNodeCache_,1);
	hold on; hdPickedNode_(numPickedNode+1) = plot3(tarNode(1), tarNode(2), tarNode(3), ...
		'xr', 'LineWidth', 2, 'MarkerSize', 8);
	PickedNodeCache_(end+1,:) = tarNode;
end