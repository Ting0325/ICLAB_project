/* reservation stations:
 * the current design includes the following:
 * 3 ADD
 * 2 MUL
 * 3 LOAD
 * 3 Store
 * for each instruction decoded,the operation is sent directly to the
 * reservation,the corresponding operands may come from the register files or
 * the common data buss,this is determined by the rename_ctrl signal from the
 * order manager
 *
 * */
module RS_top(
	input clk,
	input rst_n,
	input operation,
	input s1,//value from register file
	input s2,
	input rename_ctrl,
//common data bus

    input valid1,
    input valid2,
    input valid3,
    input valid4,
    input valid5,
    input valid6,
    input valid7,
    input valid8,
    input cdb1,
    input cdb2,
    input cdb3,
    input cdb4,
    input cdb5,
    input cdb6,
    input cdb7,
    input cdb8,

	output ADD1_Vj,
	output ADD1_Vk,
	output ADD1_Op,
    output ADD2_Vj,
    output ADD2_Vk,
    output ADD2_Op,
    output ADD3_Vj,
    output ADD3_Vk,
    output ADD3_Op,

	output MULT1_Vj,
    output MULT1_Vk,
    output MULT1_Op,
	output MULT1_Vj,
    output MULT1_Vk,
    output MULT1_Op,

	output LOAD1_addr,
	output LOAD2_addr,
	output LOAD3_addr,
	
	output STORE1_addr,
	output STORE1_Qi,
	output STORE2_addr,
    output STORE2_Qi,
	output STORE3_addr,
    output STORE3_Qi

);

reg ADD1_busy;
reg ADD1_Op;
reg [31:0] ADD1_Vj;
reg [31:0] ADD1_Vk;
reg [31:0] ADD1_Qj;
reg [31:0] ADD1_Qk;

reg ADD2_busy;
reg ADD2_Op;
reg [31:0] ADD2_Vj;
reg [31:0] ADD2_Vk;
reg [31:0] ADD2_Qj;
reg [31:0] ADD2_Qk;

reg ADD3_busy;
reg ADD3_Op;
reg [31:0] ADD3_Vj;
reg [31:0] ADD3_Vk;
reg [31:0] ADD3_Qj;
reg [31:0] ADD3_Qk;

reg LOAD1_addr,
reg LOAD2_addr,
reg LOAD3_addr,

reg STORE1_addr,
reg STORE1_Qi,
reg STORE2_addr,
reg STORE2_Qi,
reg STORE3_addr,
reg STORE3_Qi,
//load store buffers
//
RS_arith RS_add1(
	.clk(clk),
    .rst_n(rst_n),
    .sel(),
    .Op_in(),
    .Vj_valid(),
    .Vj_in(),
    .Vk_valid(),
    .Vk_in(),
    .Qj_in(),
    .Qk_in(),
    .Vj(),
    .Vk(),
    .busy()
);

RS_arith RS_add2(
    .clk(clk),
    .rst_n(rst_n),
    .sel(),
    .Op_in(),
    .Vj_valid(),
    .Vj_in(),
    .Vk_valid(),
    .Vk_in(),
    .Qj_in(),
    .Qk_in(),
    .Vj(),
    .Vk(),
    .busy()
);

RS_arith RS_add3(
    .clk(clk),
    .rst_n(rst_n),
    .sel(),
    .Op_in(),
    .Vj_valid(),
    .Vj_in(),
    .Vk_valid(),
    .Vk_in(),
    .Qj_in(),
    .Qk_in(),
    .Vj(),
    .Vk(),
    .busy()
);

RS_arith RS_mul1(
    .clk(clk),
    .rst_n(rst_n),
    .sel(),
    .Op_in(),
    .Vj_valid(),
    .Vj_in(),
    .Vk_valid(),
    .Vk_in(),
    .Qj_in(),
    .Qk_in(),
    .Vj(),
    .Vk(),
    .busy()
);

RS_arith RS_mul2(
    .clk(clk),
    .rst_n(rst_n),
    .sel(),
    .Op_in(),
    .Vj_valid(),
    .Vj_in(),
    .Vk_valid(),
    .Vk_in(),
    .Qj_in(),
    .Qk_in(),
    .Vj(),
    .Vk(),
    .busy()
);


endmodule
