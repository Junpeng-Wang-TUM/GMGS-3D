# GMGS-3D
A Geometric Multigrid Solver (GMGS) for Large-scale Static Finite Element Simulation on 3D Cartesian Mesh 

# Target
Out of academic use, "GMGS-3D" is designed to generate the high-resolution data sets of vector (displacement) or 
2nd-order tensor (stress) field with the NORMAL PC within an AFFORDABLE time.

# Design description
"GMGS-3D" proceeds the static Finite Element Analysis (FEA) for solid objects discretized into Cartesian mesh, where,
	1) an element index based data structure is used to store the FEA stiffness matrix;
	2) combined with the Jacobian smoother, a Geometric Multigrid based V-cycle is built on the Cartesian mesh;
	3) the FEA equation is iteratively solved by Conjugate Gradient Method preconditioned with V-cycle;
	4) besides the displacement vector field, the stress tensor field also can be computed.
	
# Limitations
Geometric Multigrid method can go well with some hardware accelerating techniques, yet in this program, the author didn't 
look much into it, given his limited experience in that area, and the specific design target. Any suggestions about improving
performance are highly welcomed.

# Statistics
Experiment Environment: A desktop equipped with Intel(@) Core i7-7700k and 32GB RAM, convergence tolerance = 1.0e-3

	# Example 1: kitten
		Resolutions			DOFs				Time Costs (s)
		42x37x64			    120,198			1.49
		84x73x128			    929,961			20.7
		169x147x256			  6,732,912			349
		337x294x512			 52,499,889			4030
		428x373x650			106,873,614			8200
	# Example 2: parts
		Resolutions			DOFs				Time Costs (s)
		46x46x64			    141,744			2.74
		91x91x128			    999,342			56.1
		183x183x256			  7,570,380			208
		366x366x512			 58,608,732			2850
		464x464x650			118,761,510			5330
		