module top(
	input clk,
	input rst_n,
	input [31:0]i_instruction,
	input [18:0] i_addr,
	input i_wea,
	input start
);

reg [18:0] pc;//program counter
wire [31:0] instruction;
wire [4:0] rs1,rs2;
wire [4:0] rd;
wire [11:0] imm;
wire [31:0] rs1_data,rs2_data;
//commit bus
wire [4:0] commit_idx;
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
wire [31:0] MULT1_result;
wire  MUL2_valid;
wire [31:0] MULT2_result;
wire LS_valid;
wire [31:0]LS_value;
wire [2:0]LS_idx;


//execution unit inputs
wire [31:0] ADD1_Vj;
wire [31:0] ADD1_Vk;
wire [2:0] ADD1_op;
wire [31:0] ADD2_Vj;
wire [31:0] ADD2_Vk;
wire [2:0] ADD2_op;
wire [31:0] ADD3_Vj;
wire [31:0] ADD3_Vk;
wire [2:0] ADD3_op;
wire [31:0] MULT1_Vj;
wire [31:0] MULT1_Vk;
wire [2:0] MULT1_op;
wire [31:0] MULT2_Vj;
wire [31:0] MULT2_Vk;
wire [2:0] MULT2_op;



//d_cache
wire [31:0] dina;
wire wea; 

wire [18:0] addr_dcache;

//order manager
wire [2:0] ls_entry;
wire ls_full;
wire busy_add1, busy_add2, busy_add3;
wire busy_mul1, busy_mul2;
wire struct_haz;
wire [3:0] rs_idx;
wire [3:0] Qj, Qk; //renamed value





wire [2:0] operation;

//pc
always@(posedge clk) begin
	if(~rst_n)begin
		pc <= 0;
	end else begin
		if((struct_haz)||(~start))
			pc <= pc;
		else 
			pc <= pc+1;    // original: pc = pc+4, 1 because of using word address 
	end
end


//i-cache
i_cache i_cache0(
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
    .imm(imm)
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
	.start(start),
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
	.rd(rd),
	.Qj(Qj),
	.Qk(Qk),
    .rs_idx(rs_idx),
  	.struct_haz(struct_haz)
    
    );
    
//reservation stations
RS_top RS_top0(
	.clk(clk),
	.rst_n(rst_n),
	.operation(operation),
	.Vj(rs2_data),   //value from register file
	.Vk(rs1_data),
	.sel(rs_idx),       //select which reservation station
	.imm(imm),
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
//outputs to exe_unit
	.ADD1_Vj(ADD1_Vj),
	.ADD1_Vk(ADD1_Vk),
	.ADD1_Op(ADD1_op),
	.ADD1_start(ADD1_start),
	.ADD2_Vj(ADD2_Vj),
	.ADD2_Vk(ADD2_Vk),
	.ADD2_Op(ADD2_op),
	.ADD2_start(ADD2_start),
	.ADD3_Vj(ADD3_Vj),
	.ADD3_Vk(ADD3_Vk),
	.ADD3_Op(ADD2_op),
	.ADD3_start(ADD3_start),

	.MULT1_Vj(MULT1_Vj),
	.MULT1_Vk(MULT1_Vk),
	.MULT1_Op(MULT1_op),
	.MULT1_start(MUL1_start),
	.MULT2_Vj(MULT2_Vj),
	.MULT2_Vk(MULT2_Vk),
	.MULT2_Op(MULT2_op),
	.MULT2_start(MUL2_start),

	.LS_addr_rd(addr_dcache),
	.LS_addr_wr(addr_dcache),
	.LS_data(dina),
	.LS_wen(wea),
	.ADD1_busy(busy_add1),
    .ADD2_busy(busy_add2),
    .ADD3_busy(busy_add3),
    .MUL1_busy(busy_mul1),
    .MUL2_busy(busy_mul2),
	.LS_valid_out(LS_valid),
	.LS_idx_out(LS_idx),
	.ls_full(ls_full),
	.ls_entry(ls_entry)
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
	.Op(MULT1_op),
	.a(MULT1_Vj),
	.b(MULT1_Vk),
	.valid(MULT1_valid),
	.result(MULT1_result)
);

EXE_mul EXE_MUL2(
    .clk(clk),
    .rst_n(rst_n),
    .start(MUL2_start),
    .Op(MULT2_op),
    .a(MULT2_Vj),
    .b(MULT2_Vk),
    .valid(MULT2_valid),
    .result(MULT2_result)
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
