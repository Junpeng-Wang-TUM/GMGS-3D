%% This script declares some global variables
%% General control parameters	
global tol_; tol_ = 1.0e-3; %% convergence tolerance of iterative linear system solver
global maxIT_; maxIT_ = 20000; %% permitted maximum number of iteartion
global weightFactorJacobi_; weightFactorJacobi_ = 0.4; %% try reducing it in case failing to converge, scope: (0,1)

%% Material properties
global moduls_; moduls_ = 1.0; %% Young's modulus	
global poissonRatio_; poissonRatio_ = 0.3;	%% Poisson's ratio

%% Mesh & design domain description
global surfTriMeshStruct_; %% input triangular surface mesh for voxelizing
global voxelizedVolume_; voxelizedVolume_ = []; %% voxelized model
global finestResolutionControl_; finestResolutionControl_ = 128; %% maximum number of elements along a single dimension
global characteristicSize_; characteristicSize_ = []; %% scalar or 'empty' (the dimensionality  of the bounding box of the voxelized solid object would be nely_ * nelx_ * nelz_)
global nelx_; %% simulation resolution = nelx_ * nely_ * nelz_
global nely_;
global nelz_; 
global domainLowerBound_; %%boundaing box of the simulated solid object = [domainLowerBound_, domainUpperBound_]
global domainUpperBound_;

%% node-pick operations (to facilitate applying for boundary condition)
global PickedNodeCache_; PickedNodeCache_ = [];

%%GMGS parameters
%% minimum number of elements along a single dimension
global coarsestResolutionControl_; coarsestResolutionControl_ = 10000;
global meshHierarchy_; %%sorting from finest (1) to coarsest (end)
global nodeCoords_; %% coordinates of nodes
global numLevels_; %% number of levels of multigrid  

%%FEM analysis
global loadingCond_; loadingCond_ = []; %% applied forces
global fixingCond_; fixingCond_ = []; %% fixed nodes
global F_; %% force (right hand section)
global U_; %% displacement (solution of A*U_ = F_, A is system matrix)
global cartesianStressField_; %% Cartesian stress tensor field
global iterationHist_; iterationHist_ = []; %% statistic of iterative solver
