function ShowFEAmodel()
	global nodeCoords_;
	global meshHierarchy_;
	global loadingCond_;
	global fixingCond_;
	global domainLowerBound_;
	global domainUpperBound_;
	
	figure;
	hd = VisSurfaceMesh(meshHierarchy_(1));
	if size(fixingCond_,1)>0
		tarNodeCoord = nodeCoords_(meshHierarchy_(1).solidNodesMapVec(fixingCond_),:);
		hold on; hd(end+1) = plot3(tarNodeCoord(:,1), tarNodeCoord(:,2), tarNodeCoord(:,3), 'xk', 'LineWidth', 2, 'MarkerSize', 6);
	end
	
	if size(loadingCond_,1)>0
		coordLoadedNodes = nodeCoords_(meshHierarchy_(1).solidNodesMapVec(loadingCond_(:,1)),:);
		amplitudesF = mean(domainUpperBound_-domainLowerBound_)/5* ...
			loadingCond_(:,2:4)./vecnorm(loadingCond_(:,2:4), 2, 2);
		hold on; hd(end+1) = quiver3(coordLoadedNodes(:,1), coordLoadedNodes(:,2), coordLoadedNodes(:,3), amplitudesF(:,1), ...
			amplitudesF(:,2), amplitudesF(:,3), 0, 'Color', [1.0 0.0 0.0], 'LineWidth', 2, 'MaxHeadSize', 1, 'MaxHeadSize', 1); 		
	end
end