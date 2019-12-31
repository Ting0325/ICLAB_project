/*
 * multipiler that takes 10 cycles;
 * divider takes 40 cycles
 *
 *
 * */
module EXE_mul(
	input clk,
	input rst_n,
	input start,
	input Op,
	input [31:0] a,
	input [31:0] b,
	output valid,
	output reg [31:0] result
);
localparam IDLE = 0,BUSY = 1;
reg state,next_state;
reg [31:0] result_next;
reg [31:0] delay0,delay0_next;
reg counter, counter_next;
always@(posedge clk)begin
	if(~rst_n)begin
		result <= 0;
//		delay0 <= 0;
		counter <= 0;
	end else begin
		result <= result_next;
//		delay0 <= delay0_next;
		counter <= counter_next;	
	end
end

//computation logic
/*
always@(*)begin
	case(Op)
		1'b0:	delay0_next = a + b;
		1'b1:   delay0_next = a - b;
	endcase
end
*/
//valid control via a FSM ,control signals start and the counter value

always@(*)begin
	case(state)
		IDLE:	begin
					if(start)begin
						next_state = BUSY;
						if(Op==0)begin
							result_next = a*b;
							counter_next = 10;
						end else begin
							result_next = a/b;
							counter_next = 40
						end
					end else begin
						next_state = IDLE;
						result_next = result;
						counter_next = counter;
					end
				end
		BUSY:	begin
					counter_next = counter - 1;
					result_next = result;
					if(counter == 0)begin
						next_state = IDLE;
					end else begin
						next_state = BUSY;
					end	
				end
	endcase
end

assign valid = (counter==10)?1:0;


endmodule
