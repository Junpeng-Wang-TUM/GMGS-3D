function ShowFixingCondition(varargin)
	global nodeCoords_;
	global meshHierarchy_;
	global fixingCond_;
	if 0==nargin
		fixingCondToBeShow = fixingCond_;
	else
		fixingCondToBeShow = varargin{1};
	end
	if size(fixingCondToBeShow,1)>0
		tarNodeCoord = nodeCoords_(meshHierarchy_(1).nodMapBack(fixingCondToBeShow),:);
		hold on; hd1 = plot3(tarNodeCoord(:,1), tarNodeCoord(:,2), tarNodeCoord(:,3), 'xk', 'LineWidth', 2, 'MarkerSize', 10);
	end
end