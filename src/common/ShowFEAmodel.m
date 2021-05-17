function ShowFEAmodel()
	global meshHierarchy_;
	
	figure;
	hd = ShowSilhouetteBySurfaceMesh(meshHierarchy_(1));
	ShowFixingCondition();
	ShowLoadingCondition();
end