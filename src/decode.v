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
	output reg [3:0] operation,
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


always@(*) begin
		case(opcode)
			7'b0110011: begin 
									 case ({funct7,funct3})
											10'b0000000_000 : operation = 0; //ADD
											10'b0100000_000 : operation = 1; //SUB
											10'b0000001_000 : operation = 2; //MUL
											10'b0100001_100 : operation = 3; //DIV
									 endcase
								 end
			7'b0000011: operation = 4; //LOAD
 			7'b0100011: operation = 5; //STORE	
		endcase
end

endmodule
