function ClearPickedNodes()
	global PickedNodeCache_;
	global hdPickedNode_;
	set(hdPickedNode_, 'visible', 'off');
	hdPickedNode_ = [];
	PickedNodeCache_ = [];	
end