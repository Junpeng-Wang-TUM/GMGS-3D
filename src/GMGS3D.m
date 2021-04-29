%% ----GMGS-3D----
%% A Geometric Multigrid Solver for Large-scale Static Finite Element Simulation on 3D Cartesian Mesh 
%% Author: Junpeng Wang  
%% Copyright (c) All rights reserved.
%% Create date:	08.04.2021
%% E-mail: junpeng.wang@tum.de

clear all; clc
addpath('./common');
addpath('./kernel');
GlobalVariables;

%%1. Create Model
triFaceModelFile = '../data/kitten.ply';
finestResolutionControl_ = 128;
tStart = tic;
voxelizedVolume_ = CreateVoxilizedModel(triFaceModelFile, finestResolutionControl_);
% voxelizedVolume_ = CreateVoxilizedModel(100, 50, 50); %% Create Cuboid for test
DiscretizeDesignDomain();
disp(['Creating the Geometrical Model Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
VisSurfaceMesh(meshHierarchy_);

%%2. Interactively Applying for Boundary Condition (go to directory '../doc/User's Guidance.pdf' for help)
%%....
%%....
%%....

%%3. After Applying for Boundary Conditions, Using the Commands below to Perform the Desirable Simulation (refer to Demo.m)
% GetDeformation();
% dir = 'T'; %% 'X', 'Y', 'Z' and 'T'
% ShowDeformation(dir);
% GetCartesianStress();
% sType = 'Sigma_xx'; %% 'Sigma_xx', 'Sigma_yy', 'Sigma_zz', 'Sigma_yz', 'Sigma_zx', 'Sigma_xy'
% ShowCartesianStress(sType);