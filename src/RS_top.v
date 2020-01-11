/* reservation stations:
 * the current design includes the following:
 * 3 ADD
 * 2 MUL
 * 3 LOAD
 * 3 Store
 * for each instruction decoded,the operation is sent directly to the
 * reservation,the corresponding operands may come from the register files or
 * the common data bus,this is determined by the rename_ctrl signal from the
 * order manager
 *
 * */
module RS_top(
	input clk,
	input rst_n,
	input [2:0] operation,
	input [31:0] Vj,    
	input [31:0] Vk,	//value from register file (rs1_data)

	input [3:0] sel,//rs_idx
	input [11:0] imm,

	input [3:0] Qj,
	input [3:0] Qk,

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

	output  [31:0]ADD1_Vj,
	output  [31:0]ADD1_Vk,
	output  [2:0] ADD1_Op,
	output 	ADD1_start,
	output  [31:0]ADD2_Vj,
	output  [31:0]ADD2_Vk,
	output  [2:0] ADD2_Op,
	output 	ADD2_start,	
	output  [31:0]ADD3_Vj,
	output  [31:0]ADD3_Vk,
	output  [2:0] ADD3_Op,
	output 	ADD3_start,	

	output  [31:0]MULT1_Vj,
	output  [31:0]MULT1_Vk,
	output  [2:0] MULT1_Op,
	output 	MULT1_start,	
	output  [31:0]MULT2_Vj,
	output  [31:0]MULT2_Vk,
	output  [2:0] MULT2_Op,
	output 	MULT2_start,	
	
	output [18:0] LS_addr_rd, //read address to dcache
	output [18:0] LS_addr_wr, //write address to dcache
	output [31:0] LS_data,
	output LS_wen,
	//busy information from each reservation station
	output  ADD1_busy,
	//TO-DO:busy information from each reservation station
    output  ADD2_busy,
    output  ADD3_busy,
    output  MUL1_busy,
    output  MUL2_busy,
	output  reg LS_valid_out,//for common data bus
	output  reg [2:0] LS_idx_out,//for common data bus
	//
	output ls_full,
	output [2:0] ls_entry
);

localparam TIME_add = 2, TIME_mul = 10, TIME_div = 40;

reg [18:0] LOAD1_addr;
reg [18:0]LOAD2_addr;
reg [18:0]LOAD3_addr;

reg [18:0] STORE1_addr;
reg [3:0] STORE1_Qi;
reg [18:0] STORE2_addr;
reg [3:0] STORE2_Qi;
reg [18:0] STORE3_addr;
reg [3:0] STORE3_Qi;


wire sel_load_store, sel_add1, sel_add2, sel_add3, sel_mul1, sel_mul2;
wire LS_valid_0, LS_valid_1, LS_valid_2, LS_valid_3, LS_valid_4, LS_valid_5;

reg [31:0] Vj_add1, Vj_add2, Vj_add3, Vj_mul1, Vj_mul2;
reg Vj_valid_add1, Vj_valid_add2, Vj_valid_add3, Vj_valid_mul1, Vj_valid_mul2;

reg [31:0] Vk_add1, Vk_add2, Vk_add3, Vk_mul1, Vk_mul2;
reg Vk_valid_add1, Vk_valid_add2, Vk_valid_add3, Vk_valid_mul1, Vk_valid_mul2;

wire [3:0] Qj_add1, Qj_add2, Qj_add3, Qj_mul1, Qj_mul2;
wire [3:0] Qk_add1, Qk_add2, Qk_add3, Qk_mul1, Qk_mul2;

reg [3:0] Qj_add1_in, Qj_add2_in, Qj_add3_in, Qj_mul1_in, Qj_mul2_in;
reg [3:0] Qk_add1_in, Qk_add2_in, Qk_add3_in, Qk_mul1_in, Qk_mul2_in;

assign sel_load_store = (sel>0 && sel<7)?1:0;
assign sel_add1 = (sel==7)?1:0;
assign sel_add2 = (sel==8)?1:0;
assign sel_add3 = (sel==9)?1:0;
assign sel_mul1 = (sel==10)?1:0;
assign sel_mul2 = (sel==11)?1:0;

//Vj_valid Vk_valid logic
//Vj_ADD1
always@(*)begin
	if(sel_add1 && Qj==0)begin
		Vj_add1 = Vj;
		Vj_valid_add1 = 1;
		Qj_add1_in = 0;
	end else if(sel_add1 && Qj!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qj ==LS_idx+1 && LS_valid)begin//Qj==1,2,3,4,5,6
				Vj_add1 = LS_value;
				Vj_valid_add1 =  1;
				Qj_add1_in = 0;
			end else if(Qj ==7 && ADD1_valid)begin//Qj==7
				Vj_add1 = ADD1_result;
				Vj_valid_add1 = 1;
				Qj_add1_in = 0;
			end else if(Qj ==8 && ADD2_valid)begin//Qj==8
				Vj_add1 = ADD2_result;
				Vj_valid_add1 = 1;
				Qj_add1_in = 0;
			end else if(Qj ==9 && ADD3_valid)begin//Qj==9 ,wainting for value from ADD3
				Vj_add1 = ADD3_result;
				Vj_valid_add1 = 1;
				Qj_add1_in = 0;
			end else if(Qj ==10 && MULT1_valid)begin//Qj==10 ,wainting for value from MUL1
				Vj_add1 = MULT1_result;
				Vj_valid_add1 = 1;
				Qj_add1_in = 0;
			end else if(Qj ==10 && MULT2_valid)begin//Qj==11 ,wainting for value from MUL1
				Vj_add1 = MULT2_result;
				Vj_valid_add1 = 1;
				Qj_add1_in = 0;
			end else begin
				Vj_add1 = 0;
				Vj_valid_add1 = 0;
				Qj_add1_in = Qj;
			end
	end else if(~sel_add1 && Qj_add1==LS_idx+1 && LS_valid)begin//Qj==1,2,3,4,5,6
		Vj_add1 = LS_value;
		Vj_valid_add1 =  1;
		Qj_add1_in = 0;
	end else if(~sel_add1 && Qj_add1==7 && ADD1_valid)begin//Qj==7
		Vj_add1 = ADD1_result;
		Vj_valid_add1 = 1;
		Qj_add1_in = 0;
	end else if(~sel_add1 && Qj_add1==8 && ADD2_valid)begin//Qj==8
		Vj_add1 = ADD2_result;
		Vj_valid_add1 = 1;
		Qj_add1_in = 0;
	end else if(~sel_add1 && Qj_add1==9 && ADD3_valid)begin//Qj==9 ,wainting for value from ADD3
		Vj_add1 = ADD3_result;
		Vj_valid_add1 = 1;
		Qj_add1_in = 0;
	end else if(~sel_add1 && Qj_add1==10 && MULT1_valid)begin//Qj==10 ,wainting for value from MUL1
		Vj_add1 = MULT1_result;
		Vj_valid_add1 = 1;
		Qj_add1_in = 0;
  	end else if(~sel_add1 && Qj_add1==10 && MULT2_valid)begin//Qj==11 ,wainting for value from MUL1
		Vj_add1 = MULT2_result;
		Vj_valid_add1 = 1;
		Qj_add1_in = 0;
	end else begin
		Vj_add1 = 0;
		Vj_valid_add1 = 0;
		Qj_add1_in = Qj_add1; 
	end
end


//TO-DO:do the same for the <Vj> <Vk> s in the other reservation stations
//add2
always@(*)begin
	if(sel_add2 && Qj==0)begin
		Vj_add2 = Vj;
		Vj_valid_add2 = 1;
		Qj_add2_in = 0;
	end else if(sel_add2 && Qj!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qj ==LS_idx+1 && LS_valid)begin
				Vj_add2 = LS_value;
				Vj_valid_add2 =  1;
				Qj_add2_in = 0;
			end else if(Qj ==7 && ADD1_valid)begin
				Vj_add2 = ADD1_result;
				Vj_valid_add2 = 1;
				Qj_add2_in = 0;
			end else if(Qj ==8 && ADD2_valid)begin
				Vj_add2 = ADD2_result;
				Vj_valid_add2 = 1;
				Qj_add2_in = 0;
			end else if(Qj ==9 && ADD3_valid)begin
				Vj_add2 = ADD3_result;
				Vj_valid_add2 = 1;
				Qj_add2_in = 0;
			end else if(Qj ==10 && MULT1_valid)begin
				Vj_add2 = MULT1_result;
				Vj_valid_add2 = 1;
				Qj_add2_in = 0;
			end else if(Qj ==10 && MULT2_valid)begin
				Vj_add2 = MULT2_result;
				Vj_valid_add2 = 1;
				Qj_add2_in = 0;
			end else begin
				Vj_add2 = 0;
				Vj_valid_add2 = 0;
				Qj_add2_in = Qj;
			end
	end else if(~sel_add2 && Qj_add2==LS_idx+1 && LS_valid)begin
		Vj_add2 = LS_value;
		Vj_valid_add2 =  1;
		Qj_add2_in = 0;
	end else if(~sel_add2 && Qj_add2==7 && ADD1_valid)begin
		Vj_add2 = ADD1_result;
		Vj_valid_add2 = 1;
		Qj_add2_in = 0;
	end else if(~sel_add2 && Qj_add2==8 && ADD2_valid)begin
		Vj_add2 = ADD2_result;
		Vj_valid_add2 = 1;
		Qj_add2_in = 0;
	end else if(~sel_add2 && Qj_add2==9 && ADD3_valid)begin
		Vj_add2 = ADD3_result;
		Vj_valid_add2 = 1;
		Qj_add2_in = 0;
	end else if(~sel_add2 && Qj_add2==10 && MULT1_valid)begin
		Vj_add2 = MULT1_result;
		Vj_valid_add2 = 1;
		Qj_add2_in = 0;
  	end else if(~sel_add2 && Qj_add2==10 && MULT2_valid)begin
		Vj_add2 = MULT2_result;
		Vj_valid_add2 = 1;
		Qj_add2_in = 0;
	end else begin
		Vj_add2 = 0;
		Vj_valid_add2 = 0;
		Qj_add2_in = Qj_add2; 
	end
end

//add3
always@(*)begin
	if(sel_add3 && Qj==0)begin
		Vj_add3 = Vj;
		Vj_valid_add3 = 1;
		Qj_add3_in = 0;
	end else if(sel_add3 && Qj!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qj ==LS_idx+1 && LS_valid)begin
				Vj_add3 = LS_value;
				Vj_valid_add3 =  1;
				Qj_add3_in = 0;
			end else if(Qj ==7 && ADD1_valid)begin
				Vj_add3 = ADD1_result;
				Vj_valid_add3 = 1;
				Qj_add3_in = 0;
			end else if(Qj ==8 && ADD2_valid)begin
				Vj_add3 = ADD2_result;
				Vj_valid_add3 = 1;
				Qj_add3_in = 0;
			end else if(Qj ==9 && ADD3_valid)begin
				Vj_add3 = ADD3_result;
				Vj_valid_add3 = 1;
				Qj_add3_in = 0;
			end else if(Qj ==10 && MULT1_valid)begin
				Vj_add3 = MULT1_result;
				Vj_valid_add3 = 1;
				Qj_add3_in = 0;
			end else if(Qj ==10 && MULT2_valid)begin
				Vj_add3 = MULT2_result;
				Vj_valid_add3 = 1;
				Qj_add3_in = 0;
			end else begin
				Vj_add3 = 0;
				Vj_valid_add3 = 0;
				Qj_add3_in = Qj;
			end
	end else if(~sel_add3 && Qj_add3==LS_idx+1 && LS_valid)begin
		Vj_add3 = LS_value;
		Vj_valid_add3 =  1;
		Qj_add3_in = 0;
	end else if(~sel_add3 && Qj_add3==7 && ADD1_valid)begin
		Vj_add3 = ADD1_result;
		Vj_valid_add3 = 1;
		Qj_add3_in = 0;
	end else if(~sel_add3 && Qj_add3==8 && ADD2_valid)begin
		Vj_add3 = ADD2_result;
		Vj_valid_add3 = 1;
		Qj_add3_in = 0;
	end else if(~sel_add3 && Qj_add3==9 && ADD3_valid)begin
		Vj_add3 = ADD3_result;
		Vj_valid_add3 = 1;
		Qj_add3_in = 0;
	end else if(~sel_add3 && Qj_add3==10 && MULT1_valid)begin
		Vj_add3 = MULT1_result;
		Vj_valid_add3 = 1;
		Qj_add3_in = 0;
  	end else if(~sel_add3 && Qj_add3==10 && MULT2_valid)begin
		Vj_add3 = MULT2_result;
		Vj_valid_add3 = 1;
		Qj_add3_in = 0;
	end else begin
		Vj_add3 = 0;
		Vj_valid_add3 = 0;
		Qj_add3_in = Qj_add3; 
	end
end

//mul1
always@(*)begin
	if(sel_mul1 && Qj==0)begin
		Vj_mul1 = Vj;
		Vj_valid_mul1 = 1;
		Qj_mul1_in = 0;
	end else if(sel_mul1 && Qj!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qj ==LS_idx+1 && LS_valid)begin
				Vj_mul1 = LS_value;
				Vj_valid_mul1 =  1;
				Qj_mul1_in = 0;
			end else if(Qj ==7 && ADD1_valid)begin
				Vj_mul1 = ADD1_result;
				Vj_valid_mul1 = 1;
				Qj_mul1_in = 0;
			end else if(Qj ==8 && ADD2_valid)begin
				Vj_mul1 = ADD2_result;
				Vj_valid_mul1 = 1;
				Qj_mul1_in = 0;
			end else if(Qj ==9 && ADD3_valid)begin
				Vj_mul1 = ADD3_result;
				Vj_valid_mul1 = 1;
				Qj_mul1_in = 0;
			end else if(Qj ==10 && MULT1_valid)begin
				Vj_mul1 = MULT1_result;
				Vj_valid_mul1 = 1;
				Qj_mul1_in = 0;
			end else if(Qj ==10 && MULT2_valid)begin
				Vj_mul1 = MULT2_result;
				Vj_valid_mul1 = 1;
				Qj_mul1_in = 0;
			end else begin
				Vj_mul1 = 0;
				Vj_valid_mul1 = 0;
				Qj_mul1_in = Qj;
			end
	end else if(~sel_mul1 && Qj_mul1==LS_idx+1 && LS_valid)begin
		Vj_mul1 = LS_value;
		Vj_valid_mul1 =  1;
		Qj_mul1_in = 0;
	end else if(~sel_mul1 && Qj_mul1==7 && ADD1_valid)begin
		Vj_mul1 = ADD1_result;
		Vj_valid_mul1 = 1;
		Qj_mul1_in = 0;
	end else if(~sel_mul1 && Qj_mul1==8 && ADD2_valid)begin
		Vj_mul1 = ADD2_result;
		Vj_valid_mul1 = 1;
		Qj_mul1_in = 0;
	end else if(~sel_mul1 && Qj_mul1==9 && ADD3_valid)begin
		Vj_mul1 = ADD3_result;
		Vj_valid_mul1 = 1;
		Qj_mul1_in = 0;
	end else if(~sel_mul1 && Qj_mul1==10 && MULT1_valid)begin
		Vj_mul1 = MULT1_result;
		Vj_valid_mul1 = 1;
		Qj_mul1_in = 0;
  	end else if(~sel_mul1 && Qj_mul1==10 && MULT2_valid)begin
		Vj_mul1 = MULT2_result;
		Vj_valid_mul1 = 1;
		Qj_mul1_in = 0;
	end else begin
		Vj_mul1 = 0;
		Vj_valid_mul1 = 0;
		Qj_mul1_in = Qj_mul1; 
	end
end

//mul2
always@(*)begin
	if(sel_mul2 && Qj==0)begin
		Vj_mul2 = Vj;
		Vj_valid_mul2 = 1;
		Qj_mul2_in = 0;
	end else if(sel_mul2 && Qj!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qj ==LS_idx+1 && LS_valid)begin
				Vj_mul2 = LS_value;
				Vj_valid_mul2 =  1;
				Qj_mul2_in = 0;
			end else if(Qj ==7 && ADD1_valid)begin
				Vj_mul2 = ADD1_result;
				Vj_valid_mul2 = 1;
				Qj_mul2_in = 0;
			end else if(Qj ==8 && ADD2_valid)begin
				Vj_mul2 = ADD2_result;
				Vj_valid_mul2 = 1;
				Qj_mul2_in = 0;
			end else if(Qj ==9 && ADD3_valid)begin
				Vj_mul2 = ADD3_result;
				Vj_valid_mul2 = 1;
				Qj_mul2_in = 0;
			end else if(Qj ==10 && MULT1_valid)begin
				Vj_mul2 = MULT1_result;
				Vj_valid_mul2 = 1;
				Qj_mul2_in = 0;
			end else if(Qj ==10 && MULT2_valid)begin
				Vj_mul2 = MULT2_result;
				Vj_valid_mul2 = 1;
				Qj_mul2_in = 0;
			end else begin
				Vj_mul2 = 0;
				Vj_valid_mul2 = 0;
				Qj_mul2_in = Qj;
			end
	end else if(~sel_mul2 && Qj_mul2==LS_idx+1 && LS_valid)begin
		Vj_mul2 = LS_value;
		Vj_valid_mul2 =  1;
		Qj_mul2_in = 0;
	end else if(~sel_mul2 && Qj_mul2==7 && ADD1_valid)begin
		Vj_mul2 = ADD1_result;
		Vj_valid_mul2 = 1;
		Qj_mul2_in = 0;
	end else if(~sel_mul2 && Qj_mul2==8 && ADD2_valid)begin
		Vj_mul2 = ADD2_result;
		Vj_valid_mul2 = 1;
		Qj_mul2_in = 0;
	end else if(~sel_mul2 && Qj_mul2==9 && ADD3_valid)begin
		Vj_mul2 = ADD3_result;
		Vj_valid_mul2 = 1;
		Qj_mul2_in = 0;
	end else if(~sel_mul2 && Qj_mul2==10 && MULT1_valid)begin
		Vj_mul2 = MULT1_result;
		Vj_valid_mul2 = 1;
		Qj_mul2_in = 0;
  	end else if(~sel_mul2 && Qj_mul2==10 && MULT2_valid)begin
		Vj_mul2 = MULT2_result;
		Vj_valid_mul2 = 1;
		Qj_mul2_in = 0;
	end else begin
		Vj_mul2 = 0;
		Vj_valid_mul2 = 0;
		Qj_mul2_in = Qj_mul2; 
	end
end

always@(*)begin
	if(sel_add1 && Qk==0)begin
		Vk_add1 = Vk;
		Vk_valid_add1 = 1;
		Qk_add1_in = 0;
	end else if(sel_add1 && Qk!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qk ==LS_idx+1 && LS_valid)begin
				Vk_add1 = LS_value;
				Vk_valid_add1 =  1;
				Qk_add1_in = 0;
			end else if(Qk ==7 && ADD1_valid)begin
				Vk_add1 = ADD1_result;
				Vk_valid_add1 = 1;
				Qk_add1_in = 0;
			end else if(Qk ==8 && ADD2_valid)begin
				Vk_add1 = ADD2_result;
				Vk_valid_add1 = 1;
				Qk_add1_in = 0;
			end else if(Qk ==9 && ADD3_valid)begin
				Vk_add1 = ADD3_result;
				Vk_valid_add1 = 1;
				Qk_add1_in = 0;
			end else if(Qk ==10 && MULT1_valid)begin
				Vk_add1 = MULT1_result;
				Vk_valid_add1 = 1;
				Qk_add1_in = 0;
			end else if(Qk ==10 && MULT2_valid)begin
				Vk_add1 = MULT2_result;
				Vk_valid_add1 = 1;
				Qk_add1_in = 0;
			end else begin
				Vk_add1 = 0;
				Vk_valid_add1 = 0;
				Qk_add1_in = Qk;
			end
	end else if(~sel_add1 && Qk_add1==LS_idx+1 && LS_valid)begin
		Vk_add1 = LS_value;
		Vk_valid_add1 =  1;
		Qk_add1_in = 0;
	end else if(~sel_add1 && Qk_add1==7 && ADD1_valid)begin
		Vk_add1 = ADD1_result;
		Vk_valid_add1 = 1;
		Qk_add1_in = 0;
	end else if(~sel_add1 && Qk_add1==8 && ADD2_valid)begin
		Vk_add1 = ADD2_result;
		Vk_valid_add1 = 1;
		Qk_add1_in = 0;
	end else if(~sel_add1 && Qk_add1==9 && ADD3_valid)begin
		Vk_add1 = ADD3_result;
		Vk_valid_add1 = 1;
		Qk_add1_in = 0;
	end else if(~sel_add1 && Qk_add1==10 && MULT1_valid)begin
		Vk_add1 = MULT1_result;
		Vk_valid_add1 = 1;
		Qk_add1_in = 0;
  	end else if(~sel_add1 && Qk_add1==10 && MULT2_valid)begin
		Vk_add1 = MULT2_result;
		Vk_valid_add1 = 1;
		Qk_add1_in = 0;
	end else begin
		Vk_add1 = 0;
		Vk_valid_add1 = 0;
		Qk_add1_in = Qk_add1; 
	end
end


//TO-DO:do the same for the <Vk> <Vk> s in the other reservation stations
//add2
always@(*)begin
	if(sel_add2 && Qk==0)begin
		Vk_add2 = Vk;
		Vk_valid_add2 = 1;
		Qk_add2_in = 0;
	end else if(sel_add2 && Qk!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qk ==LS_idx+1 && LS_valid)begin
				Vk_add2 = LS_value;
				Vk_valid_add2 =  1;
				Qk_add2_in = 0;
			end else if(Qk ==7 && ADD1_valid)begin
				Vk_add2 = ADD1_result;
				Vk_valid_add2 = 1;
				Qk_add2_in = 0;
			end else if(Qk ==8 && ADD2_valid)begin
				Vk_add2 = ADD2_result;
				Vk_valid_add2 = 1;
				Qk_add2_in = 0;
			end else if(Qk ==9 && ADD3_valid)begin
				Vk_add2 = ADD3_result;
				Vk_valid_add2 = 1;
				Qk_add2_in = 0;
			end else if(Qk ==10 && MULT1_valid)begin
				Vk_add2 = MULT1_result;
				Vk_valid_add2 = 1;
				Qk_add2_in = 0;
			end else if(Qk ==10 && MULT2_valid)begin
				Vk_add2 = MULT2_result;
				Vk_valid_add2 = 1;
				Qk_add2_in = 0;
			end else begin
				Vk_add2 = 0;
				Vk_valid_add2 = 0;
				Qk_add2_in = Qk;
			end
	end else if(~sel_add2 && Qk_add2==LS_idx+1 && LS_valid)begin
		Vk_add2 = LS_value;
		Vk_valid_add2 =  1;
		Qk_add2_in = 0;
	end else if(~sel_add2 && Qk_add2==7 && ADD1_valid)begin
		Vk_add2 = ADD1_result;
		Vk_valid_add2 = 1;
		Qk_add2_in = 0;
	end else if(~sel_add2 && Qk_add2==8 && ADD2_valid)begin
		Vk_add2 = ADD2_result;
		Vk_valid_add2 = 1;
		Qk_add2_in = 0;
	end else if(~sel_add2 && Qk_add2==9 && ADD3_valid)begin
		Vk_add2 = ADD3_result;
		Vk_valid_add2 = 1;
		Qk_add2_in = 0;
	end else if(~sel_add2 && Qk_add2==10 && MULT1_valid)begin
		Vk_add2 = MULT1_result;
		Vk_valid_add2 = 1;
		Qk_add2_in = 0;
  	end else if(~sel_add2 && Qk_add2==10 && MULT2_valid)begin
		Vk_add2 = MULT2_result;
		Vk_valid_add2 = 1;
		Qk_add2_in = 0;
	end else begin
		Vk_add2 = 0;
		Vk_valid_add2 = 0;
		Qk_add2_in = Qk_add2; 
	end
end

//add3
always@(*)begin
	if(sel_add3 && Qk==0)begin
		Vk_add3 = Vk;
		Vk_valid_add3 = 1;
		Qk_add3_in = 0;
	end else if(sel_add3 && Qk!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qk ==LS_idx+1 && LS_valid)begin
				Vk_add3 = LS_value;
				Vk_valid_add3 =  1;
				Qk_add3_in = 0;
			end else if(Qk ==7 && ADD1_valid)begin
				Vk_add3 = ADD1_result;
				Vk_valid_add3 = 1;
				Qk_add3_in = 0;
			end else if(Qk ==8 && ADD2_valid)begin
				Vk_add3 = ADD2_result;
				Vk_valid_add3 = 1;
				Qk_add3_in = 0;
			end else if(Qk ==9 && ADD3_valid)begin
				Vk_add3 = ADD3_result;
				Vk_valid_add3 = 1;
				Qk_add3_in = 0;
			end else if(Qk ==10 && MULT1_valid)begin
				Vk_add3 = MULT1_result;
				Vk_valid_add3 = 1;
				Qk_add3_in = 0;
			end else if(Qk ==10 && MULT2_valid)begin
				Vk_add3 = MULT2_result;
				Vk_valid_add3 = 1;
				Qk_add3_in = 0;
			end else begin
				Vk_add3 = 0;
				Vk_valid_add3 = 0;
				Qk_add3_in = Qk;
			end
	end else if(~sel_add3 && Qk_add3==LS_idx+1 && LS_valid)begin
		Vk_add3 = LS_value;
		Vk_valid_add3 =  1;
		Qk_add3_in = 0;
	end else if(~sel_add3 && Qk_add3==7 && ADD1_valid)begin
		Vk_add3 = ADD1_result;
		Vk_valid_add3 = 1;
		Qk_add3_in = 0;
	end else if(~sel_add3 && Qk_add3==8 && ADD2_valid)begin
		Vk_add3 = ADD2_result;
		Vk_valid_add3 = 1;
		Qk_add3_in = 0;
	end else if(~sel_add3 && Qk_add3==9 && ADD3_valid)begin
		Vk_add3 = ADD3_result;
		Vk_valid_add3 = 1;
		Qk_add3_in = 0;
	end else if(~sel_add3 && Qk_add3==10 && MULT1_valid)begin
		Vk_add3 = MULT1_result;
		Vk_valid_add3 = 1;
		Qk_add3_in = 0;
  	end else if(~sel_add3 && Qk_add3==10 && MULT2_valid)begin
		Vk_add3 = MULT2_result;
		Vk_valid_add3 = 1;
		Qk_add3_in = 0;
	end else begin
		Vk_add3 = 0;
		Vk_valid_add3 = 0;
		Qk_add3_in = Qk_add3; 
	end
end

//mul1
always@(*)begin
	if(sel_mul1 && Qk==0)begin
		Vk_mul1 = Vk;
		Vk_valid_mul1 = 1;
		Qk_mul1_in = 0;
	end else if(sel_mul1 && Qk!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qk ==LS_idx+1 && LS_valid)begin
				Vk_mul1 = LS_value;
				Vk_valid_mul1 =  1;
				Qk_mul1_in = 0;
			end else if(Qk ==7 && ADD1_valid)begin
				Vk_mul1 = ADD1_result;
				Vk_valid_mul1 = 1;
				Qk_mul1_in = 0;
			end else if(Qk ==8 && ADD2_valid)begin
				Vk_mul1 = ADD2_result;
				Vk_valid_mul1 = 1;
				Qk_mul1_in = 0;
			end else if(Qk ==9 && ADD3_valid)begin
				Vk_mul1 = ADD3_result;
				Vk_valid_mul1 = 1;
				Qk_mul1_in = 0;
			end else if(Qk ==10 && MULT1_valid)begin
				Vk_mul1 = MULT1_result;
				Vk_valid_mul1 = 1;
				Qk_mul1_in = 0;
			end else if(Qk ==10 && MULT2_valid)begin
				Vk_mul1 = MULT2_result;
				Vk_valid_mul1 = 1;
				Qk_mul1_in = 0;
			end else begin
				Vk_mul1 = 0;
				Vk_valid_mul1 = 0;
				Qk_mul1_in = Qk;
			end
	end else if(~sel_mul1 && Qk_mul1==LS_idx+1 && LS_valid)begin
		Vk_mul1 = LS_value;
		Vk_valid_mul1 =  1;
		Qk_mul1_in = 0;
	end else if(~sel_mul1 && Qk_mul1==7 && ADD1_valid)begin
		Vk_mul1 = ADD1_result;
		Vk_valid_mul1 = 1;
		Qk_mul1_in = 0;
	end else if(~sel_mul1 && Qk_mul1==8 && ADD2_valid)begin
		Vk_mul1 = ADD2_result;
		Vk_valid_mul1 = 1;
		Qk_mul1_in = 0;
	end else if(~sel_mul1 && Qk_mul1==9 && ADD3_valid)begin
		Vk_mul1 = ADD3_result;
		Vk_valid_mul1 = 1;
		Qk_mul1_in = 0;
	end else if(~sel_mul1 && Qk_mul1==10 && MULT1_valid)begin
		Vk_mul1 = MULT1_result;
		Vk_valid_mul1 = 1;
		Qk_mul1_in = 0;
  	end else if(~sel_mul1 && Qk_mul1==10 && MULT2_valid)begin
		Vk_mul1 = MULT2_result;
		Vk_valid_mul1 = 1;
		Qk_mul1_in = 0;
	end else begin
		Vk_mul1 = 0;
		Vk_valid_mul1 = 0;
		Qk_mul1_in = Qk_mul1; 
	end
end

//mul2
always@(*)begin
	if(sel_mul2 && Qk==0)begin
		Vk_mul2 = Vk;
		Vk_valid_mul2 = 1;
		Qk_mul2_in = 0;
	end else if(sel_mul2 && Qk!=0)begin//the selected reservation station can recive the correct waiting data frm the CDB ,in the same cycle
			if(Qk ==LS_idx+1 && LS_valid)begin
				Vk_mul2 = LS_value;
				Vk_valid_mul2 =  1;
				Qk_mul2_in = 0;
			end else if(Qk ==7 && ADD1_valid)begin
				Vk_mul2 = ADD1_result;
				Vk_valid_mul2 = 1;
				Qk_mul2_in = 0;
			end else if(Qk ==8 && ADD2_valid)begin
				Vk_mul2 = ADD2_result;
				Vk_valid_mul2 = 1;
				Qk_mul2_in = 0;
			end else if(Qk ==9 && ADD3_valid)begin
				Vk_mul2 = ADD3_result;
				Vk_valid_mul2 = 1;
				Qk_mul2_in = 0;
			end else if(Qk ==10 && MULT1_valid)begin
				Vk_mul2 = MULT1_result;
				Vk_valid_mul2 = 1;
				Qk_mul2_in = 0;
			end else if(Qk ==10 && MULT2_valid)begin
				Vk_mul2 = MULT2_result;
				Vk_valid_mul2 = 1;
				Qk_mul2_in = 0;
			end else begin
				Vk_mul2 = 0;
				Vk_valid_mul2 = 0;
				Qk_mul2_in = Qk;
			end
	end else if(~sel_mul2 && Qk_mul2==LS_idx+1 && LS_valid)begin
		Vk_mul2 = LS_value;
		Vk_valid_mul2 =  1;
		Qk_mul2_in = 0;
	end else if(~sel_mul2 && Qk_mul2==7 && ADD1_valid)begin
		Vk_mul2 = ADD1_result;
		Vk_valid_mul2 = 1;
		Qk_mul2_in = 0;
	end else if(~sel_mul2 && Qk_mul2==8 && ADD2_valid)begin
		Vk_mul2 = ADD2_result;
		Vk_valid_mul2 = 1;
		Qk_mul2_in = 0;
	end else if(~sel_mul2 && Qk_mul2==9 && ADD3_valid)begin
		Vk_mul2 = ADD3_result;
		Vk_valid_mul2 = 1;
		Qk_mul2_in = 0;
	end else if(~sel_mul2 && Qk_mul2==10 && MULT1_valid)begin
		Vk_mul2 = MULT1_result;
		Vk_valid_mul2 = 1;
		Qk_mul2_in = 0;
  	end else if(~sel_mul2 && Qk_mul2==10 && MULT2_valid)begin
		Vk_mul2 = MULT2_result;
		Vk_valid_mul2 = 1;
		Qk_mul2_in = 0;
	end else begin
		Vk_mul2 = 0;
		Vk_valid_mul2 = 0;
		Qk_mul2_in = Qk_mul2; 
	end
end

always@(*) begin
	case({LS_valid_0,LS_valid_1,LS_valid_2,LS_valid_3,LS_valid_4,LS_valid_5})
		6'b100000: begin LS_idx_out = 0; LS_valid_out = LS_valid_0; end
		6'b010000: begin LS_idx_out = 1; LS_valid_out = LS_valid_1; end
		6'b001000: begin LS_idx_out = 2; LS_valid_out = LS_valid_2; end
		6'b000100: begin LS_idx_out = 3; LS_valid_out = LS_valid_3; end
		6'b000010: begin LS_idx_out = 4; LS_valid_out = LS_valid_4; end
		6'b000001: begin LS_idx_out = 5; LS_valid_out = LS_valid_5; end
		default:	begin LS_idx_out = 0; LS_valid_out = 0; end
	endcase
end


//load store buffers
LS_buff LS_buff(
	.ADD1_valid(ADD1_valid),
	.ADD2_valid(ADD2_valid),
	.ADD3_valid(ADD3_valid),
	.MUL1_valid(MULT1_valid),
	.MUL2_valid(MULT2_valid),
	.LS_valid(LS_valid),
	.ADD1_result(ADD1_result),
	.ADD2_result(ADD2_result),
	.ADD3_result(ADD3_result),
	.MUL1_result(MULT1_result),
	.MUL2_result(MULT2_result),
	.LS_value(LS_value),
	.LS_idx(LS_idx),

	.clk(clk),
	.rst_n(rst_n),
	.sel(sel_load_store),
	.Op_in(operation),
	.offset(imm),
	.rs(Vk),//is the value from the register that contains the address (i.e rs1 ) value is from Vk
	.Vi_in(Vj),//is the value from the register that contains the data to be stored (i.e rs2 ) value is from Vj
	.Qi_in(Qj),//the renamed value for rs2
	.rd_addr(LS_addr_rd),
	.wr_addr(LS_addr_wr),
	.data_out(LS_data),
	.wen(LS_wen),
	.valid_out0(LS_valid_0),
	.valid_out1(LS_valid_1),
	.valid_out2(LS_valid_2),
	.valid_out3(LS_valid_3),
	.valid_out4(LS_valid_4),
	.valid_out5(LS_valid_5),
	.ls_full(ls_full),
	.ls_entry(ls_entry)
);




//
RS_add RS_add1
(
	.clk(clk),
    .rst_n(rst_n),
    .sel(sel_add1),	//indicatates that this reservation staion is selected during issue
    .Op_in(operation),
    .Vj_valid(Vj_valid_add1),	//logic of this signal is in this module
    .Vj_in(Vj_add1),//value may come from regfile when the inst is issued or when the data it is waiting for on the common data bus is valid
    .Vk_valid(Vk_valid_add1),
    .Vk_in(Vk_add1),
    .Qj_in(Qj_add1_in),//input from order manager
    .Qk_in(Qk_add1_in),
    .Vj(ADD1_Vj),	//output to exe units
    .Vk(ADD1_Vk),
	.Qj(Qj_add1),   //for Vj_valid control in RS_top 
    .Qk(Qk_add1),
	.Op(ADD1_Op),
	.start(ADD1_start),		
    .busy(ADD1_busy)	//output busy information to the order manager
);

RS_add RS_add2
(
	.clk(clk),
    .rst_n(rst_n),
    .sel(sel_add2),	
    .Op_in(operation),
    .Vj_valid(Vj_valid_add2),	
    .Vj_in(Vj_add2),
    .Vk_valid(Vk_valid_add2),
    .Vk_in(Vk_add2),
    .Qj_in(Qj_add2_in),
    .Qk_in(Qk_add2_in),
    .Vj(ADD2_Vj),	
    .Vk(ADD2_Vk),
	.Qj(Qj_add2),   
    .Qk(Qk_add2),
	.Op(ADD2_Op),
	.start(ADD2_start),	
    .busy(ADD2_busy)	
);

RS_add RS_add3
(
	.clk(clk),
    .rst_n(rst_n),
    .sel(sel_add3),	
    .Op_in(operation),
    .Vj_valid(Vj_valid_add3),	
    .Vj_in(Vj_add3),
    .Vk_valid(Vk_valid_add3),
    .Vk_in(Vk_add3),
    .Qj_in(Qj_add3_in),
    .Qk_in(Qk_add3_in),
    .Vj(ADD3_Vj),	
    .Vk(ADD3_Vk),
	.Qj(Qj_add3),   
    .Qk(Qk_add3),
	.Op(ADD3_Op),
	.start(ADD3_start),
    .busy(ADD3_busy)	
);

RS_mul RS_mul1
(
	.clk(clk),
    .rst_n(rst_n),
    .sel(sel_mul1),	
    .Op_in(operation),
    .Vj_valid(Vj_valid_mul1),	
    .Vj_in(Vj_mul1),
    .Vk_valid(Vk_valid_mul1),
    .Vk_in(Vk_mul1),
    .Qj_in(Qj_mul1_in),
    .Qk_in(Qk_mul1_in),
    .Vj(MULT1_Vj),	
    .Vk(MULT1_Vk),
	.Qj(Qj_mul1),   
    .Qk(Qk_mul1),
	.Op(MULT1_Op),
	.start(MULT1_start),
    .busy(MUL1_busy)	
);

RS_mul RS_mul2
(
	.clk(clk),
    .rst_n(rst_n),
    .sel(sel_mul2),	
    .Op_in(operation),
    .Vj_valid(Vj_valid_mul2),	
    .Vj_in(Vj_mul2),
    .Vk_valid(Vk_valid_mul2),
    .Vk_in(Vk_mul2),
    .Qj_in(Qj_mul2_in),
    .Qk_in(Qk_mul2_in),
    .Vj(MULT2_Vj),	
    .Vk(MULT2_Vk),
	.Qj(Qj_mul2),   
    .Qk(Qk_mul2),
	.Op(MULT2_Op),
	.start(MULT2_start),
    .busy(MUL2_busy)	
);


endmodule
