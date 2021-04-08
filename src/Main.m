%% ----GMGS-3D----
%% Author: Junpeng Wang  
%% Copyright (c) All rights reserved.
%% Create date:	08.04.2021
%% E-mail: junpeng.wang@tum.de

clear all; clc
addpath('./common');
addpath('./kernel');
GlobalVariables;

%%1. Input
%%==================================================================================================
%%===============================================DEMO===============================================
%%==================================================================================================
%%Example 1: ---  bumpy_torus
triFaceModelFile = '../data/kitten.ply';
%% Exp. 1.1 resolution = 64;
% finestResolutionControl_ = 64;
% fixingCond_ = load('../data/demo_BC_kitten_64_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_kitten_64_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
%% Exp. 1.2 resolution = 128;
finestResolutionControl_ = 128;
fixingCond_ = load('../data/demo_BC_kitten_128_fixedNodes.dat');
loadingCond_ = load('../data/demo_BC_kitten_128_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
%% Exp. 1.3 resolution = 256;
% finestResolutionControl_ = 256;
% fixingCond_ = load('../data/demo_BC_kitten_256_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_kitten_256_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
%% Exp. 1.4 resolution = 512;
% finestResolutionControl_ = 512;
% fixingCond_ = load('../data/demo_BC_kitten_512_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_kitten_512_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
%% Exp. 1.5 resolution = 650;
% finestResolutionControl_ = 650;
% fixingCond_ = load('../data/demo_BC_kitten_650_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_kitten_650_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------

%%Example 2: ---  parts
% triFaceModelFile = '../data/parts.ply';
%% Exp. 2.1 resolution = 64;
% finestResolutionControl_ = 64;
% fixingCond_ = load('../data/demo_BC_parts_64_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_64_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
%% Exp. 2.2 resolution = 128;
% finestResolutionControl_ = 128;
% fixingCond_ = load('../data/demo_BC_parts_128_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_128_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
%% Exp. 2.3 resolution = 256;
% finestResolutionControl_ = 256;
% fixingCond_ = load('../data/demo_BC_parts_256_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_256_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
%% Exp. 2.4 resolution = 512;
% finestResolutionControl_ = 512;
% fixingCond_ = load('../data/demo_BC_parts_512_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_512_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
%% Exp. 2.5 resolution = 650;
% finestResolutionControl_ = 650;
% fixingCond_ = load('../data/demo_BC_parts_650_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_650_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------

%%2. create voxilized model
tStart = tic;
voxelizedVolume_ = CreateVoxilizedModel(triFaceModelFile, finestResolutionControl_);
DiscretizeDesignDomain();
disp(['Creating the Geometrical Model Costs: ' sprintf('%10.3g',toc(tStart)) 's']);

%%3. Applying for boundary condition
ShowFEAmodel();
%% For Specific Use of This Program:
%% 1) Go to "GlobalVariables.m" for Basic Settings, e.g., Material Properties and Linear System Solver-related Parameters 
%% 2) Input the Triangular Surface Mesh ("triFaceModelFile") and Target Resolution ("finestResolutionControl_")
%% 3) Interactively Applying for Boundary Conditions via the Variable "boundaryNodeCoords" (Boundary Node Coordinates) and Functions like
%%													 "./common/PickNode.m", 
%%													 "./common/InitializeFixingCond.m"
%%													 "./common/InitializeLoadingCond.m", etc.
%% boundaryNodeCoords = nodeCoords_(meshHierarchy_(1).solidNodesMapVec(meshHierarchy_(1).nodesOnBoundary),:);
ApplyBoundaryCondition();

%%4. Initializing Solver
tStart = tic;
InitializeSolver();
disp(['Initializing Solver Totally Costs : ' sprintf('%10.3g',toc(tStart)) 's']);

%%5. Solving
tStart = tic;
U_ = CG_solver(@AtX, @Vcycle, F_, tol_, maxIT_, 'printP_ON');
disp(['Solving Linear System Costs: ' sprintf('%10.3g',toc(tStart)) 's']);	

%%5. Show Deformation
totDis = vecnorm(reshape(U_,3,numel(U_)/3)',2,2);
VisScalarField(totDis, 0);