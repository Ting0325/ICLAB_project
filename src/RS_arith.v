module RS_arith(
	input clk,
	input rst_n,
	input sel,
	input [:] Op_in,
	input [31:0] Vj_valid,
	input [31:0] Vj_in,
	input [31:0] Vk_valid,
	input [31:0] Vk_in,
	input [31:0] Qj_in,
	input [31:0] Qk_in,
	output reg Vj,
	output reg Vk,
	output busy
);

reg Op;
reg Vj_next,Vk_next;
reg Qj,Qk,Qj_next,Qk_next;
reg timer,timer_next;

//FSM
reg state ,next_state;
localparam IDLE = 0,WAIT = 1,EXE = 2;
always@(posedge clk)begin
	if(~rst_n)begin
		state <= IDLE;
		 
	end else begin 
		state <= next_state;
	end
end
//next state logic
always@(*)begin
	case(state)
		IDLE:	begin
					if(sel)begin
						next_state = WAIT;
						timer_next = 2;
						Vj_next = Vj_in;
                    	Vk_next = Vk_in;
                    	Qj_next = Qj_in;
                    	Qk_next = Qk_in;
					end else begin
						next_state = IDLE;
						timer_next = 0;
						Vj_next = Vj;
	                    Vk_next = Vk;
    	                Qj_next = Qj;
        	            Qk_next = Qk;
					end
				end
		WAIT:	begin
					timer_next = timer;
					if(Qj==0&&Qk==0)begin
						next_state = EXE;
						Vj_next = Vj;
                    	Vk_next = Vk;
                    	Qj_next = Qj;
                    	Qk_next = Qk;
					end else if(Qj==0&&Vk_valid==1)begin 
						next_state = EXE;
	                    Vj_next = Vj;
	                    Vk_next = Vk_in;
    	                Qj_next = Qj;
        	            Qk_next = 0;
					end else if(Qk==0&&Vj_valid==1))begin
						next_state = EXE;
						Vj_next = Vj_in;
                    	Vk_next = Vk;
                    	Qj_next = 0;
                    	Qk_next = Qk;
					else begin
						next_state = WAIT;
	                    Vj_next = Vj;
	                    Vk_next = Vk;
	                    Qj_next = Qj;
	                    Qk_next = Qk;
					end
				end
		EXE:	begin
					timer_next = timer - 1;
					Vj_next = Vj;
                    Vk_next = Vk;
                    Qj_next = Qj;
                    Qk_next = Qk;
					if(timer == 0)
						next_state = IDLE;
					else
						next_state = EXE;
				end
		default:begin
					next_state = IDLE;
					timer_next = 0;
					Vj_next = 0;
					Vk_next = 0;
					Qj_next = 0;
					Qk_next = 0;
				end
	endcase
end

//output logic
assign busy = (state==WAIT||state==EXE)1:0;


endmodule
