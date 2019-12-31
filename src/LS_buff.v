module LS_buff(
//from common data bus
	input valid1,
	input valid2,
	input valid3,
	input valid4,
	input valid5,
	input valid6,
	input valid7,
	input valid8,
	input cdb1,
	input cdb2,
	input cdb3,
	input cdb4,
	input cdb5,
	input cdb6,
	input cdb7,
	input cdb8,
	input [31:0] cdb9,

	input clk,
	input rst_n,
	input sel,
	input Op,
	input offset,
	input rs,
	input Vi_in,
	input Qi_in,
	output rd_addr,
	output wr_addr,
	output data_out,
	output wen,
	output valid_out0,
	output valid_out1,
	output valid_out2,
	output valid_out3,
	output valid_out4,
	output valid_out5
);

localparam ENTRY0=0,ENTRY1=1,ENTRY2=2,ENTRY3=3,ENTRY4=4,ENTRY5=5;
reg state,next_state;
reg head,head_next;
reg busy[:];
reg busy_next[0:5];
reg [:] addr [0:5];
reg [:] addr_next [0:5];
reg	[:] Vi [0:5];
reg [:] Vi_next [0:5];
reg [:] Qi [0:5];
reg [:] Qi_next [0:5];
reg  Op[0:5];
reg vadid[0:5]

always@(posedge clk)begin
	if(~rst_n)begin
		state <= ENTRY0; 
		head <= 0;
	end else begin 
		state <= next_state;
		head <= head_next;
	end
end

always@(*)begin
	case(state)
		ENTRY0:	begin
					if(sel)begin
						busy_next[0] = 1;
						busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = offset+rs;
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi_in;
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi_in;
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
						nesxt_state = ENTRY1;
					end else begin
						busy_next[0] = busy[0];
						busy_next[1] = busy[1];
						busy_next[2] = busy[2];
						busy_next[3] = busy[3];
						busy_next[4] = busy[4];
						busy_next[5] = busy[5];
						addr_next[0] = addr[0];
						addr_next[1] = addr[1];
						addr_next[2] = addr[2];
						addr_next[3] = addr[3];
						addr_next[4] = addr[4];
						addr_next[5] = addr[5];
						Vi_next[0] = Vi[0];
						Vi_next[1] = Vi[1];
						Vi_next[2] = Vi[2];
						Vi_next[3] = Vi[3];
						Vi_next[4] = Vi[4];
						Vi_next[5] = Vi[5];
						Qi_next[0] = Qi[0];
						Qi_next[1] = Qi[1];
						Qi_next[2] = Qi[2];
						Qi_next[3] = Qi[3];
						Qi_next[4] = Qi[4];
						Qi_next[5] = Qi[5];
						nesxt_state = ENTRY0;
					end
				end
		ENTRY1: begin
                    if(sel)begin
                        busy_next[0] = busy[0];
                        busy_next[1] = 1;
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = offset+rs;
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        //Vi_next[0] = (Q[0]==0)?Vi[0]:/*use Q[0]and the valid for that input as selece*/;
                        if(busy[0])begin
							if(Qi[0]==0)
								Vi_next[0] = Vi[0];
								Qi[0]_next = 0;
							else if(valid1&&Q[0]==1)begin
								Vi_next[0] = cdb1;
								Qi[0]_next = 0;
							end else if(valid2&&Q[0]==2)begin
                            	Vi_next[0] = cdb2;
								Qi[0]_next = 0;
							end else if(valid3&&Q[0]==3)begin
                            	Vi_next[0] = cdb3;
								Qi[0]_next = 0;
							end else if(valid4&&Q[0]==4)begin
                            	Vi_next[0] = cdb4;
								Qi[0]_next = 0;		
							end else if(valid5&&Q[0]==5)begin
                            	Vi_next[0] = cdb5;
								Qi[0]_next = 0;
							end else if(valid6&&Q[0]==6)begin
                            	Vi_next[0] = cdb6;
								Qi[0]_next = 0;
							end else if(valid7&&Q[0]==7)begin
                            	Vi_next[0] = cdb7;
								Qi[0]_next = 0;	
							end else if(valid8&&Q[0]==8)begin
                            	Vi_next[0] = cdb8;
								Qi[0]_next = 0;		
							end else if(valid9&&Q[0]==9)begin
                            	Vi_next[0] = cdb9;
								Qi[0]_next = 0;
							end else begin
								Qi[0]_next = Qi[0];				
								Vi_next[0] = 0;
							end
						end else begin
								Qi[0]_next = 0;
                                Vi_next[0] = 0;
						end
						Vi_next[1] = Vi_in;
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
						Op_next[0] = Op_in;/*0 for load 1 for store*/;
						Op_next[1] = Op[1];
						Op_next[2] = Op[2];
						Op_next[3] = Op[3];
						Op_next[4] = Op[4];
						Op_next[5] = Op[5];
                        nesxt_state = ENTRY1;
                    end else begin
                        busy_next[0] = busy[0];
                        busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi[0];
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi[0];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        nesxt_state = ENTRY0;
                    end
                end
		ENTRY2: begin
                    if(sel)begin
                        busy_next[0] = busy[0];
                        busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi[0];
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi[0];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        nesxt_state = ENTRY1;
                    end else begin
                        busy_next[0] = busy[0];
                        busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi[0];
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi[0];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        nesxt_state = ENTRY0;
                    end
                end
		ENTRY3: begin
                    if(sel)begin
                        busy_next[0] = busy[0];
                        busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi[0];
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi[0];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        nesxt_state = ENTRY1;
                    end else begin
                        busy_next[0] = busy[0];
                        busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi[0];
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi[0];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        nesxt_state = ENTRY0;
                    end
                end	
		ENTRY4: begin
                    if(sel)begin
                        busy_next[0] = busy[0];
                        busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi[0];
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi[0];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        nesxt_state = ENTRY1;
                    end else begin
                        busy_next[0] = busy[0];
                        busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi[0];
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi[0];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        nesxt_state = ENTRY0;
                    end
                end
		ENTRY5: begin
                    if(sel)begin
                        busy_next[0] = busy[0];
                        busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi[0];
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi[0];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        nesxt_state = ENTRY1;
                    end else begin
                        busy_next[0] = busy[0];
                        busy_next[1] = busy[1];
                        busy_next[2] = busy[2];
                        busy_next[3] = busy[3];
                        busy_next[4] = busy[4];
                        busy_next[5] = busy[5];
                        addr_next[0] = addr[0];
                        addr_next[1] = addr[1];
                        addr_next[2] = addr[2];
                        addr_next[3] = addr[3];
                        addr_next[4] = addr[4];
                        addr_next[5] = addr[5];
                        Vi_next[0] = Vi[0];
                        Vi_next[1] = Vi[1];
                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[0] = Qi[0];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        nesxt_state = ENTRY0;
                    end
                end
	endcase
end

//head logic
//use a FSM to keep track of the state of the head and control busy values and
//head values
localparam IDLE;WAIT=1, EXE=2;
reg state_o,next_state_o;
reg exe_count,exe_count_next;
always@(posedge clk)begin
	if(~rst_n)begin 
		state_o <= IDLE;
		head <= 0;
		exe_count <= 0;
	end else begin
		state_o <= next_state_o; 
		head <= head_next;
		exe_count_next <= exe_count_next;
	end
end

always@(*)begin
	case(state_o)
		IDLE:	begin
					
					head_next = head;
					exe_count_next = 2;//load exe time
					if(sel)begin end
						next_state_o = WAIT;
					else begin
						next_state_o = IDLE;
					end
				end
		WAIT:	begin
					head_next = head;
					exe_count_next = 2;
					if(Q[head]==0)
						next_state_o = EXE;
					else
						next_state_o = WAIT;
				end
		EXE:	begin
					exe_count_next = exe_count - 1;
					if(exe_count==0)begin
						head_next = (head==5)?0:head+1;
						next_state_o = EXE;
					end else begin
						head_next = head;
						next_state_o = EXE;
					end		
				end
	endcase
end
//output logic
//use head value to determine where  output valus come from and validity
assign rd_addr = address[head],
assign wr_addr = address[head],
assign wen
assign data_out,
assign valid_out0 = (head==0&&exe_count==0)1:0;
assign valid_out1 =
assign valid_out2 =
assign valid_out3 =
assign valid_out4 =
assign valid_out5 =

//one valid for each entry

endmodule
