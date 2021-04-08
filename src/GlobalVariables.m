%% This script declares some global variables
%% General control parameters	
global tol_; tol_ = 1.0e-3;
global maxIT_; maxIT_ = 20000;
global weightFactorJacobi_; weightFactorJacobi_ = 0.4; %% try reducing it in case failing to converge, scope: (0,1)

%% Material properties
global moduls_; moduls_ = 1.0;				
global poissonRatio_; poissonRatio_ = 0.3;	

%% Mesh & design domain description
global surfTriMeshStruct_; %% input triangular surface mesh for voxelizing
global voxelizedVolume_; voxelizedVolume_ = [];
global finestResolutionControl_; finestResolutionControl_ = 128; %% maximum number of elements along a single dimension
global characteristicSize_; characteristicSize_ = [];
global nelx_; 
global nely_;
global nelz_;
global domainLowerBound_;
global domainUpperBound_;

%% node-pick operations (to facilitate applying for boundary condition)
global PickedNodeCache_; PickedNodeCache_ = [];

%%GMGS parameters
%% minimum number of elements along a single dimension
global coarsestResolutionControl_; coarsestResolutionControl_ = 10000;
global meshHierarchy_; %%sorting from finest (1) to coarsest (end)
global nodeCoords_;
global numLevels_;

%%FEM analysis
global loadingCond_; loadingCond_ = [];
global fixingCond_; fixingCond_ = [];
global K_; K_ = [];
global F_;
global U_;
global cartesianStressField_;
global iterationHist_; iterationHist_ = [];
