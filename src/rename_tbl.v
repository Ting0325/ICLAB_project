/*
 * keeps track of which reservation station a register is waiting on
 *
 *
 * */

module rename_tbl(
	input clk,
	input rst_n,
	input new_name_in,
	input new_name_index,
	input rs1,
	input rs2
	output Qj,
	output Qk
);


/* name for the operand registers ,zero indicates that the value in the
 * register is already valid
 *
 *
 * */
reg [:] name [0:31];
always@(posedge clk)begin
	if(rst_n)begin 
		name[0] <= 0;
		name[1] <= 0;
		name[2] <= 0;
		name[3] <= 0;
		name[4] <= 0;
		name[5] <= 0;
		name[6] <= 0;
		name[7] <= 0;
		name[8] <= 0;
		name[9] <= 0;
		name[10] <= 0;
		name[11] <= 0;
		name[12] <= 0;
		name[13] <= 0;
		name[14] <= 0;
		name[15] <= 0;
		name[16] <= 0;
		name[17] <= 0;
		name[18] <= 0;
		name[19] <= 0;
		name[20] <= 0;
		name[21] <= 0;
		name[22] <= 0;
		name[23] <= 0;
		name[24] <= 0;
		name[25] <= 0;
		name[26] <= 0;
		name[27] <= 0;
		name[28] <= 0;
		name[29] <= 0;
		name[30] <= 0;
		name[31] <= 0;					
	end else begin 
		name[new_name_index] <= name[new_name_in];
	end
end
assign Qj = name[rs1];
assign Qk = name[rs2];
endmodule
