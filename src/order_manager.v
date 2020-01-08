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
	input [3:0] operation,
	//busy info from reservation stations
	input ls_entry,
    input ls_full,
	input busy_add1,
	input busy_add2,
	input busy_add3,
	input busy_mul1,
	input busy_mul2,	
	//input cdb
	input ADD1_valid,
	input [31:0] ADD1_result,
	input ADD2_valid,
	input [31:0] ADD2_result,
	input ADD3_valid,
	input [31:0] ADD3_result,
	input MULT1_valid,
	input [31:0] MULT1_result,
	input MULT2_valid,
	input [31:0] MULT2_result,
	input LS_valid,
	input [31:0] LS_value,
	input [2:0] LS_idx,
	input [4:0] rs1,
	input [4:0] rs2,

	output [5:0] commit_idx,
	output [31:0] commit_data,
	output commit_wen,
	output [3:0] Qj,
	output [3:0] Qk,
	output [3:0] rs_idx,
	output struct_haz
);

//wires for busy signals from reorder buffer
wire busy_rb0,busy_rb1,busy_rb2,busy_rb3,busy_rb4,busy_rb5,busy_rb6,busy_rb7;
//assigned reorder buffer idx
wire [2:0] reorder_buffer_idx,

wire [3:0] new_name;
wire [4:0] new_name_index;
wire [4:0] to_zero_index;
wire [3:0] original_name;
wire commit;


//instruction handler
inst_handler inst_handler0(
	.clk(clk),
	.rst_n(rst_n),
	.instruction(instruction),
	.operation(operation),

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
reorder_buff_top reorder_buff_top0(
	.clk(clk),
	.rst_n(rst_n),
	.index_rb(reorder_buffer_idx),//the assigned reorder buffer entry
	.index_rs(rs_idx),//the assigned reservation station
	.instruction(instruction),
	//cdb
	.ADD1_valid(ADD1_valid),
	.ADD1_result(ADD1_result),
	.ADD2_valid(ADD2_valid),
	.ADD2_result(ADD2_result),
	.ADD3_valid(ADD3_valid),
	.ADD3_result(ADD3_result),
	.MULT1_valid(MULT1_valid),
	.MULT1_result(MULT1_result),
	.MULT2_valid(MULT2_valid),
	.MULT2_result(MULT2_result),
	.LS_valid(LS_valid),
	.LS_value(LS_value),
	.LS_idx(LS_idx),
	.rs1(rs1),
	.rs2(rs2),

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
	.commit_original_name(original_name),
);

//renaming table

rename_tbl rename_tbl0(
	.clk(clk),
	.rst_n(rst_n),
	.new_name_in(new_name),//from inst_mamanger or is set to zero during commit (if there are no pending instructions whose dest is being committed), or rs_idx (new_name) assigned by inst_handler
	.new_name_index(new_name_index), // from inst rd
	.to_zero_index(rs_idx),
	.original_name(original_name),	
	.commit(commit_wen),
	.rs1(rs1), //input from decoder
	.rs2(rs2),
	.Qj(Qj),   //output to reservation stations
	.Qk(Qk),
);

endmodule
