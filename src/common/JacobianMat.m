function [detJ, invJ] = JacobianMat(dShape, coord);
	Jac = [
		dShape(1,:)*coord(:,1) 	dShape(1,:)*coord(:,2) dShape(1,:)*coord(:,3)
		dShape(2,:)*coord(:,1) 	dShape(2,:)*coord(:,2) dShape(2,:)*coord(:,3)
		dShape(3,:)*coord(:,1) 	dShape(3,:)*coord(:,2) dShape(3,:)*coord(:,3)		
	];
	detJ = det(Jac);
	invJ = inv(Jac);
end