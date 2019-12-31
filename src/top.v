module top(
	input clk,
	input rst_n,
	input [20:0]i_instruction,
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

wire operation;
//i-cache
cache i_cache(
  .dina(i_instruction),       //data to be written
  .addrb(pc),  //address for read operation
  .addra(i_addr), //address for write operation
  .wea(i_wea),         //write enable signal
  .clk(clk),  //clock signal for write operation
  .doutb(instruction)           //read data
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
	.read_data2(rs1_data),
// Port Write
	.write_addr(),
	.write_data(),
	.write()//write enable
);
//order manager
	//renaming table
	//reorder buffer 
order_manager order_manager0(

);
//reservation stations
RS RS0(
	.clk(clk),
	.rst_n(rsn),
	.operation(),
	.s1(),//value from register file
	.s2(),
	.rename_ctrl(),
//common data bus
	.valid1(),
	.valid2(),
	.valid3(),
	.valid4(),
	.valid5(),
	.valid6(),
	.valid7(),
	.valid8(),
	.cdb1(),
	.cdb2(),
	.cdb3(),
	.cdb4(),
	.cdb5(),
	.cdb6(),
	.cdb7(),
	.cdb8(),

	.ADD1_Vj(),
	.ADD1_Vk(),
	.ADD1_Op(),
	.ADD2_Vj(),
	.ADD2_Vk(),
	.ADD2_Op(),
	.ADD3_Vj(),
	.ADD3_Vk(),
	.ADD3_Op(),

	.MULT1_Vj(),
	.MULT1_Vk(),
	.MULT1_Op(),
	.MULT1_Vj(),
	.MULT1_Vk(),
	.MULT1_Op(),

	.LOAD1_addr(),
	.LOAD2_addr(),
	.LOAD3_addr(),

	.STORE1_addr(),
	.STORE1_Qi(),
	.STORE2_addr(),
	.STORE2_Qi(),
	.STORE3_addr(),
	.STORE3_Qi()

);

//execution unit

EXE_add EXE_ADD1(
	.clk(clk),
	.rst_n(rst_n),
	.start(ADD1_start),
	.Op(ADD1_op),
	.a(ADD1_Vj),
	.b(ADD1_Vk),
	.valid(),
	.result(ADD1_result)
);

EXE_add EXE_ADD2(
    .clk(clk),
    .rst_n(rst_n),
    .start(ADD2_start),
    .Op(ADD2_op),
    .a(ADD2_Vj),
    .b(ADD2_Vk),
    .valid(),
    .result(ADD2_result)
);

EXE_add EXE_ADD3(
    .clk(clk),
    .rst_n(rst_n),
    .start(ADD3_start),
    .Op(ADD3_op),
    .a(ADD3_Vj),
    .b(ADD3_Vk),
    .valid(),
    .result(ADD3_result)
);


EXE_mul EXE_MUL1(
	.clk(clk),
	.rst_n(rst_n),
	.start(MUL1_start),
	.Op(MUL1_op),
	.a(MUL1_Vj),
	.b(MUL1_Vk),
	.valid(),
	.result(MUL1_result)
);

EXE_mul EXE_MUL2(
    .clk(clk),
    .rst_n(rst_n),
    .start(MUL2_start),
    .Op(MUL2_op),
    .a(MUL2_Vj),
    .b(MUL2_Vk),
    .valid(),
    .result(MUL2_result)
);


//d-cache
cache d_cache(
	.dina(),       //data to be written
	.addrb(),  //address for read operation
	.addra(), //address for write operation
	.wea(),         //write enable signal
	.clk(),  //clock signal for write operation
	.doutb()           //read data
);

endmodule
