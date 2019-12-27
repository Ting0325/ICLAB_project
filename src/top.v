module top(
	input clk,
	input rst_n
);

reg [9:0] pc;//program counter
wire [31:0] instruction;
wire [4:0] rs1,rs2;
wire [4:0] rs1_data,rs2_data;
//common data bus
wire [31:0] ADD1_Vj;
wire [31:0] ADD1_Vk;
wire [31:0] ADD2_Vj;
wire [31:0] ADD2_Vk;
wire [31:0] ADD3_Vj;
wire [31:0] ADD3_Vk;
wire [31:0] MULT1_Vj;
wire [31:0] MULT1_Vk,
wire [31:0] MULT2_Vj,
wire [31:0] MULT2_Vk,

//i-cache
cache i_cache(
  .dina(),       //data to be written
  .addrb(),  //address for read operation
  .addra(), //address for write operation
  .wea(),         //write enable signal
  .clk(),  //clock signal for write operation
  .doutb()           //read data
);
//decoder
decoder decoder0(
    .instruction(instruction),
    .operation(),
    .rd(),
    .rs1(rs1),
    .rs2(rs2),
    .imm(),
);
//register file
regfile regfile0(
	.clk(clk),
	.rst_n(),
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
EXE_add EXE_add0(
	.clk(),
	.rst_n(),
	.start(),
	.Op(),
	.a(),
	.b(),
	.valid(),
	.result()
);
EXE_mul EXE_mul1(
);
EXE_div EXE_div0(
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
