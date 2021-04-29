%% ----GMGS-3D----DEMO----
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
%%Un-comment one of examples below to test
%%--------------------------------------------------------------------------------------------------
% triFaceModelFile = '../data/kitten.ply';
% finestResolutionControl_ = 64;
% fixingCond_ = load('../data/demo_BC_kitten_64_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_kitten_64_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
triFaceModelFile = '../data/kitten.ply';
finestResolutionControl_ = 128;
fixingCond_ = load('../data/demo_BC_kitten_128_fixedNodes.dat');
loadingCond_ = load('../data/demo_BC_kitten_128_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
% triFaceModelFile = '../data/kitten.ply';
% finestResolutionControl_ = 256;
% fixingCond_ = load('../data/demo_BC_kitten_256_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_kitten_256_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
% triFaceModelFile = '../data/kitten.ply';
% finestResolutionControl_ = 512;
% fixingCond_ = load('../data/demo_BC_kitten_512_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_kitten_512_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
% triFaceModelFile = '../data/kitten.ply';
% finestResolutionControl_ = 650;
% fixingCond_ = load('../data/demo_BC_kitten_650_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_kitten_650_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
% triFaceModelFile = '../data/parts.ply';
% finestResolutionControl_ = 64;
% fixingCond_ = load('../data/demo_BC_parts_64_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_64_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
% triFaceModelFile = '../data/parts.ply';
% finestResolutionControl_ = 128;
% fixingCond_ = load('../data/demo_BC_parts_128_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_128_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
% triFaceModelFile = '../data/parts.ply';
% finestResolutionControl_ = 256;
% fixingCond_ = load('../data/demo_BC_parts_256_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_256_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
% triFaceModelFile = '../data/parts.ply';
% finestResolutionControl_ = 512;
% fixingCond_ = load('../data/demo_BC_parts_512_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_512_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------
% triFaceModelFile = '../data/parts.ply';
% finestResolutionControl_ = 650;
% fixingCond_ = load('../data/demo_BC_parts_650_fixedNodes.dat');
% loadingCond_ = load('../data/demo_BC_parts_650_loadingVec.dat');
%%--------------------------------------------------------------------------------------------------

tStart = tic;
voxelizedVolume_ = CreateVoxilizedModel(triFaceModelFile, finestResolutionControl_);
DiscretizeDesignDomain();
disp(['Creating the Geometrical Model Costs: ' sprintf('%10.3g',toc(tStart)) 's']);
ShowFEAmodel();

%%2. Compute Deformation
GetDeformation();
dir = 'T'; %% 'X', 'Y', 'Z' and 'T'
ShowDeformation(dir);

%%3. Compute Cartesian Stress if Necessary
% GetCartesianStress();
% sType = 'Sigma_xx'; %% 'Sigma_xx', 'Sigma_yy', 'Sigma_zz', 'Sigma_yz', 'Sigma_zx', 'Sigma_xy'
% ShowCartesianStress(sType);
