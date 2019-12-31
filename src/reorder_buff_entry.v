module reorder_buff_entry(
	input clk,
	input rest_n,
	input sel,//indicates that this reorder buffer entry has been selected to log the incomming instruction
	input instruction_in,//the incomming instruction
	input from_rs_idx,//this value is assigned by the instruction handler,allocating a reservation station for the incomming instruction
	input dest,//drom decode //might not need
	input valid,//from common data bus
	input value
	output dest,
	output wen,
	output busy,
);

reg wen,wen_next;
reg dest,dest_next;
reg val,val_next;
reg instruction,instruction_next;
reg busy;
//FSM
localparam IDLE = 0 , WAIT = 1,COMMIT = 2;
reg state,next_state;

always(posedge clk)begin
	if(~rst_n)begin
		
	end else begin
		
	end
end

always@(*)begin
	case(state)
		IDLE:	begin
					busy = 0;
					wen_next = 0;
					if(sel)begin 
						next_state = WAIT;
						instruction_next <= instruction_in;
						value
					end	else begin
					end 
				end
		WAIT:	begin 
					busy  = 1; 
					instruction_next = instruction;
					if(valid)begin 
						next_state = COMMIT;
						wen_next = 1;
						val_next = value_in;
					end else begin 
						next_state = WAIT;
				 		wen_next = 0;
					end
				end
		COMMIT: begin
					
					instruction_next = instruction;
					busy = 1;
					wen_next = 0
					next_state = IDLE;
				end
	endcase
end


assign dest = instruction[];

endmodule
