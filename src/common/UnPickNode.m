function UnPickNode()
	global PickedNodeCache_;
	global hdPickedNode_;
    dcm_obj = datacursormode;
    info_struct = getCursorInfo(dcm_obj);
    tarNode = info_struct.Position;
	if size(PickedNodeCache_,1)>0
		[minVal minValPos] = min(vecnorm(tarNode-PickedNodeCache_,2,2));
		set(hdPickedNode_(minValPos), 'visible', 'off');
		hdPickedNode_(minValPos) = [];
		PickedNodeCache_(minValPos,:) = [];
	end
end