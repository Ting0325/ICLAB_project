module top(
	input clk,
	input rst_n,
	input [31:0]i_instruction,
	input [5:0] i_addr,
	input i_wea,
	input start
);

reg [9:0] pc;//program counter
wire [31:0] instruction;
wire [4:0] rs1,rs2;
wire [4:0] rd;
wire [11:0] imm;
wire [4:0] rs1_data,rs2_data;
//commit bus
wire [5:0] commit_idx;
wire [31:0]commit_data;
wire commit_wen;
//common data bus
wire  ADD1_valid;
wire [31:0] ADD1_result;
wire  ADD2_valid;
wire [31:0] ADD2_result;
wire  ADD3_valid;
wire [31:0] ADD3_result;
wire  MUL1_valid;
wire [31:0] MUL1_result;
wire  MUL2_valid;
wire [31:0] MUL2_result;
wire LS_valid;
wire [31:0]LS_value;
wire [2:0]LS_idx;
//execution unit inputs
wire [31:0] ADD1_Vj;
wire [31:0] ADD1_Vk;
wire [31:0] ADD1_op;
wire [31:0] ADD2_Vj;
wire [31:0] ADD2_Vk;
wire [31:0] ADD2_op;
wire [31:0] ADD3_Vj;
wire [31:0] ADD3_Vk;
wire [31:0] ADD3_op;
wire [31:0] MULT1_Vj;
wire [31:0] MULT1_Vk;
wire [31:0] MULT1_op;
wire [31:0] MULT2_Vj;
wire [31:0] MULT2_Vk;
wire [31:0] MULT2_op;

wire ADD1_busy;
wire ADD2_busy;
wire ADD3_busy;
wire MUL1_busy;
wire MUL2_busy;

//d_cache
wire [31:0] dina;
wire [18:0] addra, addrb;
wire wea; 

//order manager
wire [2:0] ls_entry;
wire ls_full;
wire busy_add1, busy_add2, busy_add3;
wire busy_mul1, busy_mul2;
wire struct_haz;
wire [3:0] rs_idx;
wire [3:0] Qj, Qk; //renamed value





wire [3:0] operation;

//pc
always@(posedge clk) begin
	if((struct_haz)||(~start))
		pc <= pc;
	else 
		pc <= pc+4;
end


//i-cache
cache i_cache(
  .dina(i_instruction),       //data to be written
  .addrb(pc),  							 //address for read operation
  .addra(i_addr), 					 //address for write operation
  .wea(i_wea),         			 //write enable signal
  .clk(clk),  							 //clock signal for write operation
  .doutb(instruction)         //read data
);
//decoder
decoder decoder0(
    .instruction(instruction),
    .operation(operation),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .imm(imm),
);
//register file
regfile regfile0(
	.clk(clk),
	.rst_n(rst_n),
// Port Read 1
	.read_addr1(rs1),
	.read_data1(rs1_data),
// Port Read 2
	.read_addr2(rs2),
	.read_data2(rs2_data),
// Port Write
	.write_addr(commit_idx),
	.write_data(commit_data),
	.write(commit_wen)//write enable
);
//order manager
	//renaming table
	//reorder buffer 
order_manager order_manager(
	.clk(clk),
	.rst_n(rst_n),
	.instruction(instruction),
	.operation(operation),
    //busy info from reservation stations
	.ls_entry(ls_entry),
	.ls_full(ls_full),
	.busy_add1(busy_add1),
	.busy_add2(busy_add2),
	.busy_add3(busy_add3),
	.busy_mul1(busy_mul1),
	.busy_mul2(busy_mul2),
	.commit_idx(commit_idx),
	.commit_data(commit_data),
	.commit_wen(commit_wen),
	//common data bus
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
	
	.Qj(Qj),
	.Qk(Qk),
    .rs_idx(rs_idx),
  	.struct_haz(struct_haz)
    
    );
    
//reservation stations
RS_top RS_top0(
	.clk(clk),
	.rst_n(rsn),
	.operation(operation),
	.rs1_data(rs1_data),//value from register file
	.rs2_data(rs2_data),
//rename
	.Qj(Qj),
	.Qk(Qk),
//common data bus
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
//outputs to EXE
	.ADD1_Vj(ADD1_Vj),
	.ADD1_Vk(ADD1_Vk),
	.ADD1_Op(ADD1_op),
	.ADD2_Vj(ADD2_Vj),
	.ADD2_Vk(ADD2_Vk),
	.ADD2_Op(ADD2_op),
	.ADD3_Vj(ADD3_Vj),
	.ADD3_Vk(ADD3_Vk),
	.ADD3_Op(ADD2_op),

	.MULT1_Vj(MULT1_Vj),
	.MULT1_Vk(MULT1_Vk),
	.MULT1_Op(MULT1_op),
	.MULT2_Vj(MULT2_Vj),
	.MULT2_Vk(MULT2_Vk),
	.MULT2_Op(MULT2_op),

	.LS_addr(addr_dcache)
	.LS_data(dina)
	.LS_wen(wea)
	.ADD1_busy()
	.ADD2_busy()
	.ADD3_busy()
	.MUL1_busy()
	.MUL2_busy()
);

//execution unit

EXE_add EXE_ADD1(
	.clk(clk),
	.rst_n(rst_n),
	.start(ADD1_start),
	.Op(ADD1_op),
	.a(ADD1_Vj),
	.b(ADD1_Vk),
	.valid(ADD1_valid),
	.result(ADD1_result)
);

EXE_add EXE_ADD2(
    .clk(clk),
    .rst_n(rst_n),
    .start(ADD2_start),
    .Op(ADD2_op),
    .a(ADD2_Vj),
    .b(ADD2_Vk),
    .valid(ADD2_valid),
    .result(ADD2_result)
);

EXE_add EXE_ADD3(
    .clk(clk),
    .rst_n(rst_n),
    .start(ADD3_start),
    .Op(ADD3_op),
    .a(ADD3_Vj),
    .b(ADD3_Vk),
    .valid(ADD3_valid),
    .result(ADD3_result)
);


EXE_mul EXE_MUL1(
	.clk(clk),
	.rst_n(rst_n),
	.start(MUL1_start),
	.Op(MUL1_op),
	.a(MUL1_Vj),
	.b(MUL1_Vk),
	.valid(MUL1_valid),
	.result(MUL1_result)
);

EXE_mul EXE_MUL2(
    .clk(clk),
    .rst_n(rst_n),
    .start(MUL2_start),
    .Op(MUL2_op),
    .a(MUL2_Vj),
    .b(MUL2_Vk),
    .valid(MUl2_valid),
    .result(MUL2_result)
);


//d-cache
cache d_cache(
	.dina(dina),       			 //data to be written
	.addrb(addr_dcache),  		 //address for read operation
	.addra(addr_dcache),     //address for write operation
	.wea(wea),       //write enable signal
	.clk(clk),       //clock signal for write operation
	.doutb(LS_value)      //read data
);

endmodule
