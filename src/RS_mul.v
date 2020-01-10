module RS_mul
(
	input clk,
	input rst_n,
	input sel,
	input [2:0] Op_in,
	input Vj_valid,		//input control for Vj
	input [31:0] Vj_in,	//from CDB or regfile
	input Vk_valid,
	input [31:0] Vk_in,	
	input [3:0] Qj_in, //renamed value for rs1
	input [3:0] Qk_in, //renamed value for rs2
	output reg [31:0] Vj,	
	output reg [31:0] Vk,
	output reg [3:0] Qj,	//for Vj_valid control in RS_top 
	output reg [3:0] Qk,
	output reg [2:0] Op,
	output start,
	output busy
);

reg [2:0] Op_next;
reg [31:0] Vj_next,Vk_next;
reg [3:0] Qj_next,Qk_next;
reg [5:0] timer,timer_next;

//FSM
reg [1:0] state ,next_state;
localparam IDLE = 0,WAIT = 1,EXE = 2;
always@(posedge clk)begin
	if(~rst_n)begin
		state <= IDLE;
		Vj <= 0;
		Vk <= 0;
		Qj <= 0;
		Qk <= 0; 
        Op <= 0;
		timer <= 0;
	end else begin 
		state <= next_state;
        Vj <= Vj_next;
        Vk <= Vk_next;
        Qj <= Qj_next;
        Qk <= Qk_next;
        Op <= Op_next;
		timer <= timer_next;
	end
end
//next state logic
always@(*)begin
	case(state)
		IDLE:	begin                       //instruction issue to reservation station
					if(sel)begin
						next_state = WAIT;
						timer_next = (Op_in==2)?10:40;
						Vj_next = Vj_in;
                    	Vk_next = Vk_in;
                    	Qj_next = Qj_in;
                    	Qk_next = Qk_in;
                        Op_next = Op_in;
					end else begin
						next_state = IDLE;
						timer_next = 0;
						Vj_next = 0;
	                    Vk_next = 0;
    	                Qj_next = 0;
        	            Qk_next = 0;
                        Op_next = 0;
					end
				end
		WAIT:	begin
					timer_next = timer;
                    Op_next = Op;
					if(Qj==0&&Qk==0)begin
						next_state = EXE;
						Vj_next = Vj;
             			Vk_next = Vk;
              			Qj_next = Qj;
             			Qk_next = Qk;
					end else if(Qj==0 && Qk!=0 && Vk_valid==1)begin 
						next_state = EXE;
	                    Vj_next = Vj;
	                    Vk_next = Vk_in;
    	                Qj_next = Qj;
        	            Qk_next = 0;
					end else if(Qk==0 && Qj!=0 && Vj_valid==1)begin
						next_state = EXE;
						Vj_next = Vj_in;
                    	Vk_next = Vk;
                    	Qj_next = 0;
                    	Qk_next = Qk;
					end else if(Qk!=0 && Qj!=0 && Vj_valid==1 && Vk_valid==1)begin
						next_state = EXE;
						Vj_next = Vj_in;
                    	Vk_next = Vk_in;
                    	Qj_next = 0;
                    	Qk_next = 0;
					end else begin
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
                    Op_next = Op;					
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
                    Op_next = 0;					
				end
	endcase
end

//output logic
assign busy = (state==WAIT||state==EXE)?1:0;
assign start = (state==EXE)?1:0;

endmodule
