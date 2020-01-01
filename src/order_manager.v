/* the order manager consists of the renaming table and the reorder buffer
 * it sends a control signal to the reservation stations, notifying the
 * reservation stations wether or not the incomming data from the register
 * file is valid ,and how to rename 
 * 
 *
 *
 * */
module order_manager(
	input clk,
	input rst_n,
	
	input [31:0] instruction,
	//busy info from reservation stations
	input ls_entry,
    input ls_full,
	input busy_add1,
	input busy_add2,
	input busy_add3,
	input busy_mul1,
	input busy_mul2,	
	//input cdb
	output commit_idx,
	output commit_data,
	output commit_wen,
	output Qj,
	output Qk,
	output rs_idx,
	output struct_haz	
);

//wires for busy signals from reorder buffer
wire busy_rb0,busy_rb1,busy_rb2,busy_rb3,busy_rb4,busy_rb5,busy_rb6,busy_rb7;
//assigned reorder buffer idx
wire reorder_buffer_idx,
//instruction handler
inst_handler inst_handler0(
	.clk(clk),
	.rst_n(rst_n),
	.instruction(instruction),
	.operation(),
	.ls_entry(ls_entry),
	.ls_full(ls_full),
	.busy_add1(busy_add1),
	.busy_add2(busy_add2),
	.busy_add3(busy_add3),
	.busy_mul1(busy_mul1),
	.busy_mul2(busy_mul2),
	.busy_rb0(busy_rb0),
	.busy_rb1(busy_rb1),
	.busy_rb2(busy_rb2),
	.busy_rb3(busy_rb3),
	.busy_rb4(busy_rb4),
	.busy_rb5(busy_rb5),
	.busy_rb6(busy_rb6),
	.busy_rb7(busy_rb7),
	.reorder_buffer_idx(reorder_buffer_idx),
	.reservation_station_idx(rs_idx),//output to reservation stations
	.struct_haz(struct_haz)
);

//reorder buffer
reorder_buff reorder_buff0(
	.clk(clk),
	.rst_n(rst_n),
	.index_rb(reorder_buffer_idx),//the assigned reorder buffer entry
	.index_rs(rs_idx),//the assigned reservation station
	.instruction(instruction),
	.busy0(busy_rb0),
	.busy1(busy_rb1),
	.busy2(busy_rb2),
	.busy3(busy_rb3),
	.busy4(busy_rb4),
	.busy5(busy_rb5),
	.busy6(busy_rb6),
	.busy7(busy_rb7),
	.commit_idx(commit_idx),//output to register file
	.commit_data(commit_data),
	.commit_valid(commit_wen),
);

//renaming table

rename_tbl rename_tbl0(
	.clk(clk),
	.rst_n(rst_n),
	.new_name_in(),//from inst_mamanger or is set to zero during commit
	.new_name_index(),
	.rs1(),//input drom decoder
	.rs2(),
	.Qj(Qj),//output to reservation stations
	.Qk(Qk),
);

endmodule
