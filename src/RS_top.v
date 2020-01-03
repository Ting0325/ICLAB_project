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
	input [4:0] rs1_data, //value from register file
	input [4:0] rs2_data,

	input [4:0] Qj, Qk;

//common data bus
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

	output [31:0]ADD1_Vj,
	output [31:0]ADD1_Vk,
	output [3:0] ADD1_Op,
	output [31:0]ADD2_Vj,
	output [31:0]ADD2_Vk,
	output [3:0] ADD2_Op,
	output [31:0]ADD3_Vj,
	output [31:0]ADD3_Vk,
	output [3:0] ADD3_Op,

	output [31:0]MULT1_Vj,
	output [31:0]MULT1_Vk,
	output [3:0] MULT1_Op,
	output [31:0]MULT2_Vj,
	output [31:0]MULT2_Vk,
	output [3:0] MULT2_Op,
	
	output LS_addr,
	output LS_data,
	output LS_wen

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

wire sel_load_store, sel_add1, sel_add2, sel_add3, sel_mul1, sel_mul2;

assign sel_load_store = (sel>0 && sel<7)?1:0;
assign sel_add1 = (sel==7)?1:0;
assign sel_add2 = (sel==8)?1:0;
assign sel_add3 = (sel==9)?1:0;
assign sel_mul1 = (sel==10)?1:0;
assign sel_mul2 = (sel==11)?1:0;
//Vj Vk  valid logic
//Vj_ADD1
always@(*)begin
	if(sel_add1 && Qj==0)begin
		Vj_add1 = Vj;
		Vj_valid_add1 = 1;
/*
	end else if(sel_add1 && Qj!=0)begin
		Vj_add1 = 0;
		Vj_valid_add1 = 0;
*/
	end else if(~sel_add1 && Qj_add1==LS_idx && LS_valid)begin//Qj==1,2,3,4,5,6
        Vj_add1 = LS_value;
        Vj_valid_add1 =  1;
	end else if(~sel_add1 && Qj_add1==7 && ADD1_valid)begin//Qj==7
        Vj_add1 = ADD1_result11;
        Vj_valid_add1 = 1;
	end end else if(~sel_add1 && Qj_add1==8 && ADD2_valid)begin//Qj==8
        Vj_add1 = ADD2_result;
        Vj_valid_add1 = 1;
	end else if(~sel_add1 && Qj_add1==9 && ADD3_valid)begin//Qj==9 ,wainting for value from ADD3
        Vj_add1 = ADD3_result;
        Vj_valid_add1 = 1;
	end else if(~sel_add1 && Qj_add1==10 && MUL1_valid)begin//Qj==10 ,wainting for value from MUL1
        Vj_add1 = MUL1_result;
        Vj_valid_add1 = 1;
  	end else if(~sel_add1 && Qj_add1==10 && MUL2_valid)begin//Qj==11 ,wainting for value from MUL1
        Vj_add1 = MUL2_result;
        Vj_valid_add1 = 1;
	else begin
        Vj_add1 = 0;
        Vj_valid_add1 = 0;
	end
end
//...
//load store buffers
//
RS_arith RS_add1(
	.clk(clk),
    .rst_n(rst_n),
    .sel(sel_add1),
    .Op_in(),
    .Vj_valid(),
    .Vj_in(Vj_add1),
    .Vk_valid(),
    .Vk_in(),
    .Qj_in(),
    .Qk_in(),
    .Vj(),
    .Vk(),
	.Qj(),   //for Vj_valid control in RS_top 
    .Qk(),
    .busy()
);

RS_arith RS_add2(
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel_add2),
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
    .sel(sel_add3),
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
    .sel(sel_mul1),
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
    .sel(sel_mul2),
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
