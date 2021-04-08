function B = ElementStrainMatrix(dShape, invJ)
	global domainType_;
	derivatives = invJ * dShape;
	dNds1 = derivatives(1,:);	dNdt1 = derivatives(2,:);	dNdp1 = derivatives(3,:);
	dNds2 = derivatives(4,:);	dNdt2 = derivatives(5,:);	dNdp2 = derivatives(6,:);
	dNds3 = derivatives(7,:);	dNdt3 = derivatives(8,:);	dNdp3 = derivatives(9,:);	
	dNds4 = derivatives(10,:);	dNdt4 = derivatives(11,:);	dNdp4 = derivatives(12,:);	
	dNds5 = derivatives(13,:);	dNdt5 = derivatives(14,:);	dNdp5 = derivatives(15,:);	
	dNds6 = derivatives(16,:);	dNdt6 = derivatives(17,:);	dNdp6 = derivatives(18,:);	
	dNds7 = derivatives(19,:);	dNdt7 = derivatives(20,:);	dNdp7 = derivatives(21,:);
	dNds8 = derivatives(22,:);	dNdt8 = derivatives(23,:);	dNdp8 = derivatives(24,:);
	
	B1_1 = [dNds1(1) 0 0; 0 dNdt1(1) 0; 0 0 dNdp1(1); 0 dNdp1(1) dNdt1(1); dNdp1(1) 0 dNds1(1); dNdt1(1) dNds1(1) 0];			
	B1_2 = [dNds1(2) 0 0; 0 dNdt1(2) 0; 0 0 dNdp1(2); 0 dNdp1(2) dNdt1(2); dNdp1(2) 0 dNds1(2); dNdt1(2) dNds1(2) 0];			
	B1_3 = [dNds1(3) 0 0; 0 dNdt1(3) 0; 0 0 dNdp1(3); 0 dNdp1(3) dNdt1(3); dNdp1(3) 0 dNds1(3); dNdt1(3) dNds1(3) 0];			
	B1_4 = [dNds1(4) 0 0; 0 dNdt1(4) 0; 0 0 dNdp1(4); 0 dNdp1(4) dNdt1(4); dNdp1(4) 0 dNds1(4); dNdt1(4) dNds1(4) 0];			
	B1_5 = [dNds1(5) 0 0; 0 dNdt1(5) 0; 0 0 dNdp1(5); 0 dNdp1(5) dNdt1(5); dNdp1(5) 0 dNds1(5); dNdt1(5) dNds1(5) 0];			
	B1_6 = [dNds1(6) 0 0; 0 dNdt1(6) 0; 0 0 dNdp1(6); 0 dNdp1(6) dNdt1(6); dNdp1(6) 0 dNds1(6); dNdt1(6) dNds1(6) 0];			
	B1_7 = [dNds1(7) 0 0; 0 dNdt1(7) 0; 0 0 dNdp1(7); 0 dNdp1(7) dNdt1(7); dNdp1(7) 0 dNds1(7); dNdt1(7) dNds1(7) 0];			
	B1_8 = [dNds1(8) 0 0; 0 dNdt1(8) 0; 0 0 dNdp1(8); 0 dNdp1(8) dNdt1(8); dNdp1(8) 0 dNds1(8); dNdt1(8) dNds1(8) 0];
	
	B2_1 = [dNds2(1) 0 0; 0 dNdt2(1) 0; 0 0 dNdp2(1); 0 dNdp2(1) dNdt2(1); dNdp2(1) 0 dNds2(1); dNdt2(1) dNds2(1) 0];			
	B2_2 = [dNds2(2) 0 0; 0 dNdt2(2) 0; 0 0 dNdp2(2); 0 dNdp2(2) dNdt2(2); dNdp2(2) 0 dNds2(2); dNdt2(2) dNds2(2) 0];			
	B2_3 = [dNds2(3) 0 0; 0 dNdt2(3) 0; 0 0 dNdp2(3); 0 dNdp2(3) dNdt2(3); dNdp2(3) 0 dNds2(3); dNdt2(3) dNds2(3) 0];			
	B2_4 = [dNds2(4) 0 0; 0 dNdt2(4) 0; 0 0 dNdp2(4); 0 dNdp2(4) dNdt2(4); dNdp2(4) 0 dNds2(4); dNdt2(4) dNds2(4) 0];			
	B2_5 = [dNds2(5) 0 0; 0 dNdt2(5) 0; 0 0 dNdp2(5); 0 dNdp2(5) dNdt2(5); dNdp2(5) 0 dNds2(5); dNdt2(5) dNds2(5) 0];			
	B2_6 = [dNds2(6) 0 0; 0 dNdt2(6) 0; 0 0 dNdp2(6); 0 dNdp2(6) dNdt2(6); dNdp2(6) 0 dNds2(6); dNdt2(6) dNds2(6) 0];			
	B2_7 = [dNds2(7) 0 0; 0 dNdt2(7) 0; 0 0 dNdp2(7); 0 dNdp2(7) dNdt2(7); dNdp2(7) 0 dNds2(7); dNdt2(7) dNds2(7) 0];			
	B2_8 = [dNds2(8) 0 0; 0 dNdt2(8) 0; 0 0 dNdp2(8); 0 dNdp2(8) dNdt2(8); dNdp2(8) 0 dNds2(8); dNdt2(8) dNds2(8) 0];			
	
	B3_1 = [dNds3(1) 0 0; 0 dNdt3(1) 0; 0 0 dNdp3(1); 0 dNdp3(1) dNdt3(1); dNdp3(1) 0 dNds3(1); dNdt3(1) dNds3(1) 0];			
	B3_2 = [dNds3(2) 0 0; 0 dNdt3(2) 0; 0 0 dNdp3(2); 0 dNdp3(2) dNdt3(2); dNdp3(2) 0 dNds3(2); dNdt3(2) dNds3(2) 0];			
	B3_3 = [dNds3(3) 0 0; 0 dNdt3(3) 0; 0 0 dNdp3(3); 0 dNdp3(3) dNdt3(3); dNdp3(3) 0 dNds3(3); dNdt3(3) dNds3(3) 0];			
	B3_4 = [dNds3(4) 0 0; 0 dNdt3(4) 0; 0 0 dNdp3(4); 0 dNdp3(4) dNdt3(4); dNdp3(4) 0 dNds3(4); dNdt3(4) dNds3(4) 0];			
	B3_5 = [dNds3(5) 0 0; 0 dNdt3(5) 0; 0 0 dNdp3(5); 0 dNdp3(5) dNdt3(5); dNdp3(5) 0 dNds3(5); dNdt3(5) dNds3(5) 0];			
	B3_6 = [dNds3(6) 0 0; 0 dNdt3(6) 0; 0 0 dNdp3(6); 0 dNdp3(6) dNdt3(6); dNdp3(6) 0 dNds3(6); dNdt3(6) dNds3(6) 0];			
	B3_7 = [dNds3(7) 0 0; 0 dNdt3(7) 0; 0 0 dNdp3(7); 0 dNdp3(7) dNdt3(7); dNdp3(7) 0 dNds3(7); dNdt3(7) dNds3(7) 0];			
	B3_8 = [dNds3(8) 0 0; 0 dNdt3(8) 0; 0 0 dNdp3(8); 0 dNdp3(8) dNdt3(8); dNdp3(8) 0 dNds3(8); dNdt3(8) dNds3(8) 0];
	
	B4_1 = [dNds4(1) 0 0; 0 dNdt4(1) 0; 0 0 dNdp4(1); 0 dNdp4(1) dNdt4(1); dNdp4(1) 0 dNds4(1); dNdt4(1) dNds4(1) 0];			
	B4_2 = [dNds4(2) 0 0; 0 dNdt4(2) 0; 0 0 dNdp4(2); 0 dNdp4(2) dNdt4(2); dNdp4(2) 0 dNds4(2); dNdt4(2) dNds4(2) 0];			
	B4_3 = [dNds4(3) 0 0; 0 dNdt4(3) 0; 0 0 dNdp4(3); 0 dNdp4(3) dNdt4(3); dNdp4(3) 0 dNds4(3); dNdt4(3) dNds4(3) 0];			                                                                                                      
	B4_4 = [dNds4(4) 0 0; 0 dNdt4(4) 0; 0 0 dNdp4(4); 0 dNdp4(4) dNdt4(4); dNdp4(4) 0 dNds4(4); dNdt4(4) dNds4(4) 0];			                                                                                                      
	B4_5 = [dNds4(5) 0 0; 0 dNdt4(5) 0; 0 0 dNdp4(5); 0 dNdp4(5) dNdt4(5); dNdp4(5) 0 dNds4(5); dNdt4(5) dNds4(5) 0];			                                                                                                      
	B4_6 = [dNds4(6) 0 0; 0 dNdt4(6) 0; 0 0 dNdp4(6); 0 dNdp4(6) dNdt4(6); dNdp4(6) 0 dNds4(6); dNdt4(6) dNds4(6) 0];					  		                                                                                      
	B4_7 = [dNds4(7) 0 0; 0 dNdt4(7) 0; 0 0 dNdp4(7); 0 dNdp4(7) dNdt4(7); dNdp4(7) 0 dNds4(7); dNdt4(7) dNds4(7) 0];					  		                                                                                      
	B4_8 = [dNds4(8) 0 0; 0 dNdt4(8) 0; 0 0 dNdp4(8); 0 dNdp4(8) dNdt4(8); dNdp4(8) 0 dNds4(8); dNdt4(8) dNds4(8) 0];
	
	B5_1 = [dNds5(1) 0 0; 0 dNdt5(1) 0; 0 0 dNdp5(1); 0 dNdp5(1) dNdt5(1); dNdp5(1) 0 dNds5(1); dNdt5(1) dNds5(1) 0];					  		 		 	                                                                          
	B5_2 = [dNds5(2) 0 0; 0 dNdt5(2) 0; 0 0 dNdp5(2); 0 dNdp5(2) dNdt5(2); dNdp5(2) 0 dNds5(2); dNdt5(2) dNds5(2) 0];					  		 		 	                                                                          
	B5_3 = [dNds5(3) 0 0; 0 dNdt5(3) 0; 0 0 dNdp5(3); 0 dNdp5(3) dNdt5(3); dNdp5(3) 0 dNds5(3); dNdt5(3) dNds5(3) 0];					  		 		 	                                                                          
	B5_4 = [dNds5(4) 0 0; 0 dNdt5(4) 0; 0 0 dNdp5(4); 0 dNdp5(4) dNdt5(4); dNdp5(4) 0 dNds5(4); dNdt5(4) dNds5(4) 0];					  		 		 	                                                                          
	B5_5 = [dNds5(5) 0 0; 0 dNdt5(5) 0; 0 0 dNdp5(5); 0 dNdp5(5) dNdt5(5); dNdp5(5) 0 dNds5(5); dNdt5(5) dNds5(5) 0];					  		 		 	                                                                          
	B5_6 = [dNds5(6) 0 0; 0 dNdt5(6) 0; 0 0 dNdp5(6); 0 dNdp5(6) dNdt5(6); dNdp5(6) 0 dNds5(6); dNdt5(6) dNds5(6) 0];					  		 		 	                                                                          
	B5_7 = [dNds5(7) 0 0; 0 dNdt5(7) 0; 0 0 dNdp5(7); 0 dNdp5(7) dNdt5(7); dNdp5(7) 0 dNds5(7); dNdt5(7) dNds5(7) 0];					  		 		 	                                                                          
	B5_8 = [dNds5(8) 0 0; 0 dNdt5(8) 0; 0 0 dNdp5(8); 0 dNdp5(8) dNdt5(8); dNdp5(8) 0 dNds5(8); dNdt5(8) dNds5(8) 0];
	
	B6_1 = [dNds6(1) 0 0; 0 dNdt6(1) 0; 0 0 dNdp6(1); 0 dNdp6(1) dNdt6(1); dNdp6(1) 0 dNds6(1); dNdt6(1) dNds6(1) 0];					  		 		 	 	                                                                      
	B6_2 = [dNds6(2) 0 0; 0 dNdt6(2) 0; 0 0 dNdp6(2); 0 dNdp6(2) dNdt6(2); dNdp6(2) 0 dNds6(2); dNdt6(2) dNds6(2) 0];					  		 		 	 	 	                                                                  
	B6_3 = [dNds6(3) 0 0; 0 dNdt6(3) 0; 0 0 dNdp6(3); 0 dNdp6(3) dNdt6(3); dNdp6(3) 0 dNds6(3); dNdt6(3) dNds6(3) 0];					  		 		 	 	 			                                                          
	B6_4 = [dNds6(4) 0 0; 0 dNdt6(4) 0; 0 0 dNdp6(4); 0 dNdp6(4) dNdt6(4); dNdp6(4) 0 dNds6(4); dNdt6(4) dNds6(4) 0];					  		 		 	 	 		                                                              
	B6_5 = [dNds6(5) 0 0; 0 dNdt6(5) 0; 0 0 dNdp6(5); 0 dNdp6(5) dNdt6(5); dNdp6(5) 0 dNds6(5); dNdt6(5) dNds6(5) 0];					  		 		 	 	 			                                                          
	B6_6 = [dNds6(6) 0 0; 0 dNdt6(6) 0; 0 0 dNdp6(6); 0 dNdp6(6) dNdt6(6); dNdp6(6) 0 dNds6(6); dNdt6(6) dNds6(6) 0];					  		 		 	 	 			                                                          
	B6_7 = [dNds6(7) 0 0; 0 dNdt6(7) 0; 0 0 dNdp6(7); 0 dNdp6(7) dNdt6(7); dNdp6(7) 0 dNds6(7); dNdt6(7) dNds6(7) 0];					  		 		 	 	 			                                                          
	B6_8 = [dNds6(8) 0 0; 0 dNdt6(8) 0; 0 0 dNdp6(8); 0 dNdp6(8) dNdt6(8); dNdp6(8) 0 dNds6(8); dNdt6(8) dNds6(8) 0];					  		 		 	 	 			                                                          
	
	B7_1 = [dNds7(1) 0 0; 0 dNdt7(1) 0; 0 0 dNdp7(1); 0 dNdp7(1) dNdt7(1); dNdp7(1) 0 dNds7(1); dNdt7(1) dNds7(1) 0];					  		 		 	 	 			                                                          
	B7_2 = [dNds7(2) 0 0; 0 dNdt7(2) 0; 0 0 dNdp7(2); 0 dNdp7(2) dNdt7(2); dNdp7(2) 0 dNds7(2); dNdt7(2) dNds7(2) 0];					  		 		 	 	 			                                                          
	B7_3 = [dNds7(3) 0 0; 0 dNdt7(3) 0; 0 0 dNdp7(3); 0 dNdp7(3) dNdt7(3); dNdp7(3) 0 dNds7(3); dNdt7(3) dNds7(3) 0];					  		 		 	 	 			                                                          
	B7_4 = [dNds7(4) 0 0; 0 dNdt7(4) 0; 0 0 dNdp7(4); 0 dNdp7(4) dNdt7(4); dNdp7(4) 0 dNds7(4); dNdt7(4) dNds7(4) 0];					  		 		 	 	 			                                                          
	B7_5 = [dNds7(5) 0 0; 0 dNdt7(5) 0; 0 0 dNdp7(5); 0 dNdp7(5) dNdt7(5); dNdp7(5) 0 dNds7(5); dNdt7(5) dNds7(5) 0];					  		 		 	 	 			                                                            
	B7_6 = [dNds7(6) 0 0; 0 dNdt7(6) 0; 0 0 dNdp7(6); 0 dNdp7(6) dNdt7(6); dNdp7(6) 0 dNds7(6); dNdt7(6) dNds7(6) 0];					  		 		 	 	 			                                                            
	B7_7 = [dNds7(7) 0 0; 0 dNdt7(7) 0; 0 0 dNdp7(7); 0 dNdp7(7) dNdt7(7); dNdp7(7) 0 dNds7(7); dNdt7(7) dNds7(7) 0];					  		 		 	 	 			                                                            
	B7_8 = [dNds7(8) 0 0; 0 dNdt7(8) 0; 0 0 dNdp7(8); 0 dNdp7(8) dNdt7(8); dNdp7(8) 0 dNds7(8); dNdt7(8) dNds7(8) 0];
	
	B8_1 = [dNds8(1) 0 0; 0 dNdt8(1) 0; 0 0 dNdp8(1); 0 dNdp8(1) dNdt8(1); dNdp8(1) 0 dNds8(1); dNdt8(1) dNds8(1) 0];					  		 		 	 	 			                                                            
	B8_2 = [dNds8(2) 0 0; 0 dNdt8(2) 0; 0 0 dNdp8(2); 0 dNdp8(2) dNdt8(2); dNdp8(2) 0 dNds8(2); dNdt8(2) dNds8(2) 0];					  		 		 	 	 			                                                            
	B8_3 = [dNds8(3) 0 0; 0 dNdt8(3) 0; 0 0 dNdp8(3); 0 dNdp8(3) dNdt8(3); dNdp8(3) 0 dNds8(3); dNdt8(3) dNds8(3) 0];					  		 		 	 	 			                                                            
	B8_4 = [dNds8(4) 0 0; 0 dNdt8(4) 0; 0 0 dNdp8(4); 0 dNdp8(4) dNdt8(4); dNdp8(4) 0 dNds8(4); dNdt8(4) dNds8(4) 0];					  		 		 	 	 			                                                            
	B8_5 = [dNds8(5) 0 0; 0 dNdt8(5) 0; 0 0 dNdp8(5); 0 dNdp8(5) dNdt8(5); dNdp8(5) 0 dNds8(5); dNdt8(5) dNds8(5) 0];					  		 		 	 	 			                                                            
	B8_6 = [dNds8(6) 0 0; 0 dNdt8(6) 0; 0 0 dNdp8(6); 0 dNdp8(6) dNdt8(6); dNdp8(6) 0 dNds8(6); dNdt8(6) dNds8(6) 0];					  		 		 	 	 			                                                            
	B8_7 = [dNds8(7) 0 0; 0 dNdt8(7) 0; 0 0 dNdp8(7); 0 dNdp8(7) dNdt8(7); dNdp8(7) 0 dNds8(7); dNdt8(7) dNds8(7) 0];					  		 		 	 	 			                                                            
	B8_8 = [dNds8(8) 0 0; 0 dNdt8(8) 0; 0 0 dNdp8(8); 0 dNdp8(8) dNdt8(8); dNdp8(8) 0 dNds8(8); dNdt8(8) dNds8(8) 0];
	
	B = [
		B1_1 B1_2 B1_3 B1_4 B1_5 B1_6 B1_7 B1_8
		B2_1 B2_2 B2_3 B2_4 B2_5 B2_6 B2_7 B2_8
		B3_1 B3_2 B3_3 B3_4 B3_5 B3_6 B3_7 B3_8
		B4_1 B4_2 B4_3 B4_4 B4_5 B4_6 B4_7 B4_8
		B5_1 B5_2 B5_3 B5_4 B5_5 B5_6 B5_7 B5_8
		B6_1 B6_2 B6_3 B6_4 B6_5 B6_6 B6_7 B6_8
		B7_1 B7_2 B7_3 B7_4 B7_5 B7_6 B7_7 B7_8
		B8_1 B8_2 B8_3 B8_4 B8_5 B8_6 B8_7 B8_8		
	];
end
