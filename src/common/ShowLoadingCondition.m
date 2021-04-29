function ShowLoadingCondition(varargin)
	global meshHierarchy_;
	global nodeCoords_;
	global loadingCond_;
	global boundingBox_;
	if 0==nargin
		loadingCondToBeShow = loadingCond_;
	else
		loadingCondToBeShow = varargin{1};
	end	
	if size(loadingCondToBeShow,1)>0
		coordLoadedNodes = nodeCoords_(meshHierarchy_(1).nodMapBack(loadingCondToBeShow(:,1)),:);
		amplitudesF = mean(boundingBox_(2,:)-boundingBox_(1,:))/5 * loadingCondToBeShow(:,2:4)./vecnorm(loadingCondToBeShow(:,2:4), 2, 2);
		hold on; hd2 = quiver3(coordLoadedNodes(:,1), coordLoadedNodes(:,2), coordLoadedNodes(:,3), amplitudesF(:,1), ...
			amplitudesF(:,2), amplitudesF(:,3), 0, 'Color', [1.0 0.0 0.0], 'LineWidth', 2, 'MaxHeadSize', 1, 'MaxHeadSize', 1); 		
	end	
end