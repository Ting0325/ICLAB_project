always@(*) begin  
	if(waiting_for0 == LS_idx)	begin  // waiting for load.store
		valid0 = 1;
		value0 = LS_value;
	end else if(waiting_for0==7 && ADD1_valid) begin
		valid0 = 1;
		value0 = ADD1_value;
	end else if(waiting_for0==8 && ADD2_valid) begin
		valid0 = 1;
		value0 = ADD2_value;
	end else if(waiting_for0==9 && ADD2_valid) begin
		valid0 = 2;
		value0 = ADD3_value;
	end else if(waiting_for0==10 && MUL1_valid) begin
		valid0 = 2;
		value0 = MUL1_value;
	end else if(waiting_for0==11 && MUL2_valid) begin
		valid0 = 2;
		value0 = MUL2_value;
	end 
end
