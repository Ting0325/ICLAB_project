/*
 * keeps track of which reservation station a register is waiting on
 *
 *
 * */

module rename_tbl(
	input clk,
	input rst_n,
	input [3:0] new_name_in,     //assigned reservation station from inst_handler during issue
	input [4:0] new_name_index,	//destination of incoming inst.
	input [4:0] to_zero_index,   //the <dest> field of a committing reorder buffer entry
	input [3:0] original_name,		//the <from> field of a committing reorder buffer entry
	input commit,         //whether a commit is happening 
	input [4:0] rs1,
	input [4:0] rs2,
	output [3:0] Qj,
	output [3:0] Qk
);


/* name for the operand registers ,zero indicates that the value in the
 * register is already valid
 *
 *
 * 
 */
reg [3:0] name [0:31];


always@(posedge clk)begin
	if(~rst_n)begin 
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
	end 
	else begin 
		if((name[to_zero_index] == original_name) && commit && to_zero_index!=new_name_index) begin //the name hasn't been modified by later inst. in the reorder buffer
			name[to_zero_index] <= 0;
			name[new_name_index] <= new_name_in;
		end
		else //if((name[to_zero_index] == original_name) && commit && to_zero_index==new_name_index) //issue and commit has the same destination register
			name[new_name_index] <= new_name_in;
		/*
		else //if((name[to_zero_index] != original_name) || !commit) 
			name[new_name_index] <= new_name_in;
		*/
	end
end
assign Qj = name[rs1];
assign Qk = name[rs2];
endmodule
