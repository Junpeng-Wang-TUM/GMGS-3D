function ShowFEAmodel()
	global meshHierarchy_;
	
	figure;
	hd = VisSurfaceMesh(meshHierarchy_(1));
	ShowFixingCondition();
	ShowLoadingCondition();
end