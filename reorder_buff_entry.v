module reorder_buff_entry#(
	parameter entry_number = 1
)
(
	input clk,
	input rst_n,
	input sel,//indicates that this reorder buffer entry has been selected to log the incomming instruction
	input [31:0] instruction_in,//the incomming instruction
	input [3:0] from_rs_idx,//this value is assigned by the instruction handler,allocating a reservation station for the incomming instruction
	input valid,//from common data bus
	input [31:0] value,
	input [2:0] head, // to determine if it your turn to commit 
	output [4:0] dest,
	output reg wen,
	output reg busy,
	output [3:0] waiting_for // for selecting valid signal from common data bus
);

reg wen_next;
reg [4:0] dest_next;
reg [3:0] from, from_next;
reg [31:0] val,val_next;
reg [31:0] instruction,instruction_next;

//FSM
localparam IDLE = 0 , WAIT = 1,COMMIT = 2;
reg [1:0] state,next_state;


assign waiting_for = from;


always@(posedge clk)begin
	if(~rst_n)begin
		state <= 0;
		wen <= 0;
		from <= 0;//keeps track of which exe unit this instruction is waiting for
		val <= 0;
		instruction <= 0;
	end else begin
		state <= next_state;
		wen <= wen_next;
		from <= from_next;
		val <= val_next;
		instruction <= instruction_next;
	end
end



always@(*)begin
	case(state)
		IDLE:	begin
					busy = 0;
					wen_next = 0;
					if(sel)begin 
						next_state = WAIT;
						instruction_next = instruction_in;
						val_next = 0;
						from_next = from_rs_idx;
					end	else begin
						next_state = IDLE;
						instruction_next = instruction_in;
						val_next = 0;
						from_next = from;
					end 
				end
		WAIT:	begin 
					busy  = 1; 
					instruction_next = instruction;
					from_next = from;
					if(valid)begin 
						next_state = COMMIT;
						wen_next = 0;
						val_next = value;  //value = value_in, from cdb
					end else begin 
						next_state = WAIT;
				 		wen_next = 0;
						val_next = value;
					end
				end
		COMMIT: begin
					busy = 1;
					from_next = from;
					val_next = val;
					if(head==entry_number) begin
						instruction_next = 0;
						wen_next = 1;
						next_state = IDLE;
					end else begin
						instruction_next = instruction;
						wen_next = 0;
						next_state = COMMIT;
					end
				end
	endcase
end


assign dest = instruction[11:7];

endmodule
