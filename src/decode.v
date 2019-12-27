/*
 * The decoder takes in the instruction,determines the operation based on
 * opcode, funct3, funct7, also decoding rd, rs1, rs2,imm
 * This implementaion currently supports the following instructions
 * R-type:
 * ADD, SUB, DIV
 * I-type:
 * ADDI,LW
 * S-typt
 * SW
 *
 *
 *
 *
 *
 *
 * */
module decoder(
	input [31:0] instruction,
	output reg [6:0] operation,
	output [4:0] rd,
	output [4:0] rs1,
	output [4:0] rs2,
	output [11:0] imm,
);

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

assign opcode = instruction[6:0];
assign rd = instruction[11:7];
assign funct3 = instruction[14:12]
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];
assign funct7 = instruction[31:25];
assign imm = instruction[31:20];
always@(*){
	case({funct7,funct3,opcode})
		13'b0000000_000_0110011://ADD
		13'b0100000_000_0110011://SUB
				
	endcase
}

endmodule
