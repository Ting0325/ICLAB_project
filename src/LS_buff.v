module LS_buff(
//from common data bus
	input ADD1_valid,
	input ADD2_valid,
	input ADD3_valid,
	input MUL1_valid,
	input MUL2_valid,
	input LS_valid,
	input [31:0] ADD1_result,
	input [31:0] ADD2_result,
	input [31:0] ADD3_result,
	input [31:0] MUL1_result,
	input [31:0] MUL2_result,
	input [31:0] LS_value,
	input [2:0] LS_idx,

	input clk,
	input rst_n,
	input sel,
	input [2:0] Op,
	input [11:0] offset,
	input [31:0] rs,
	input [31:0] Vi_in,
	input [3:0] Qi_in,
	output [18:0] rd_addr,
	output [18:0] wr_addr,
	output [31:0] data_out,
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
reg Op[0:5];
reg valid[0:5];

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
					busy_next[1] = busy[1];
					busy_next[2] = busy[2];
					busy_next[3] = busy[3];
					busy_next[4] = busy[4];
					busy_next[5] = busy[5];
					addr_next[1] = addr[1];
					addr_next[2] = addr[2];
					addr_next[3] = addr[3];
					addr_next[4] = addr[4];
					addr_next[5] = addr[5];
					//Vi_next[0] = (Q[0]==0)?Vi[0]:/*use Q[0]and the valid for that input as selece*/;

                    if(sel)begin//the values for the current entry is controlled here
                        busy_next[0] = 1;
                        addr_next[0] = offset+rs;
						Vi_next[0] = Vi_in;
                        Qi_next[0] = Qi_in;
						Op_next[0] = Op_in;/*0 for load 1 for store*/
						next_state = ENTRY1;
                    end else begin
                        busy_next[0] = busy[0];
                        addr_next[0] = addr[0];
                        Vi_next[0] = Vi[0];
                        Qi_next[0] = Qi[0];
                        next_state = ENTRY0;
                    end

					if(busy[1])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[1] =LS_result;
							Qi_next[1] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[1] = ADD1_result;
							Qi_next[1] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[1] = ADD2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = ADD3_result;
							Qi_next[1] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[1] = MUL1_result;
							Qi_next[1] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[1] = MUL2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = cdb9;
							Qi_next[1] = 0;
						end else begin
							Vi_next[1] = 0;
							Qi_next[1] = Qi[0];
						end
					end 
					else begin
						Vi_next[1] = 0;
						Qi_next[1] = 0;
					end

					if(busy[2])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[2] =LS_result;
							Qi_next[2] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[2] = ADD1_result;
							Qi_next[2] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[2] = ADD2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = ADD3_result;
							Qi_next[2] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[2] = MUL1_result;
							Qi_next[2] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[2] = MUL2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = cdb9;
							Qi_next[2] = 0;
						end else begin
							Vi_next[2] = 0;
							Qi_next[2] = Qi[0];
						end
					end 
					else begin
						Vi_next[2] = 0;
						Qi_next[2] = 0;
					end

					if(busy[3])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[3] =LS_result;
							Qi_next[3] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[3] = ADD1_result;
							Qi_next[3] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[3] = ADD2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = ADD3_result;
							Qi_next[3] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[3] = MUL1_result;
							Qi_next[3] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[3] = MUL2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = cdb9;
							Qi_next[3] = 0;
						end else begin
							Vi_next[3] = 0;
							Qi_next[3] = Qi[0];
						end
					end 
					else begin
						Vi_next[3] = 0;
						Qi_next[3] = 0;
					end

					if(busy[4])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[4] =LS_result;
							Qi_next[4] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[4] = ADD1_result;
							Qi_next[4] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[4] = ADD2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = ADD3_result;
							Qi_next[4] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[4] = MUL1_result;
							Qi_next[4] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[4] = MUL2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = cdb9;
							Qi_next[4] = 0;
						end else begin
							Vi_next[4] = 0;
							Qi_next[4] = Qi[0];
						end
					end 
					else begin
						Vi_next[4] = 0;
						Qi_next[4] = 0;
					end

					if(busy[5])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[5] =LS_result;
							Qi_next[5] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[5] = ADD1_result;
							Qi_next[5] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[5] = ADD2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = ADD3_result;
							Qi_next[5] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[5] = MUL1_result;
							Qi_next[5] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[5] = MUL2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = cdb9;
							Qi_next[5] = 0;
						end else begin
							Vi_next[5] = 0;
							Qi_next[5] = Qi[0];
						end
					end 
					else begin
						Vi_next[5] = 0;
						Qi_next[5] = 0;
					end
                end

		ENTRY1: begin
					busy_next[0] = busy[0];
					busy_next[2] = busy[2];
					busy_next[3] = busy[3];
					busy_next[4] = busy[4];
					busy_next[5] = busy[5];
					addr_next[0] = addr[0];
					addr_next[2] = addr[2];
					addr_next[3] = addr[3];
					addr_next[4] = addr[4];
					addr_next[5] = addr[5];
					//Vi_next[0] = (Q[0]==0)?Vi[0]:/*use Q[0]and the valid for that input as selece*/;
					if(busy[0])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[0] =LS_result;
							Qi_next[0] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin//Vi_next[0] = (Q[0]==0)?Vi[0]:/*use Q[0]and the valid for that input as selece*/;
							Vi_next[0] = ADD1_result;
							Qi_next[0] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[0] = ADD2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = ADD3_result;
							Qi_next[0] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[0] = MUL1_result;
							Qi_next[0] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[0] = MUL2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = cdb9;
							Qi_next[0] = 0;
						end else begin
							Vi_next[0] = 0;
							Qi_next[0] = Qi[0];
						end
					end 
					else begin
						Vi_next[0] = 0;
						Qi_next[0] = 0;
					end
///TODO:complete the rest of the Qi_next and Vi_next for the ls_buffer entries that isn't the current entry
/*                        Vi_next[2] = Vi[2];
                        Vi_next[3] = Vi[3];
                        Vi_next[4] = Vi[4];
                        Vi_next[5] = Vi[5];
                        Qi_next[1] = Qi[1];
                        Qi_next[2] = Qi[2];
                        Qi_next[3] = Qi[3];
                        Qi_next[4] = Qi[4];
                        Qi_next[5] = Qi[5];
                        Op_next[1] = Op[1];
                        Op_next[2] = Op[2];
                        Op_next[3] = Op[3];
                        Op_next[4] = Op[4];
                        Op_next[5] = Op[5];
*/
                    if(sel)begin//the values for the current entry is controlled here
                        busy_next[1] = 1;
                        addr_next[1] = offset+rs;
						Vi_next[1] = Vi_in;
                        Qi_next[1] = Qi_in;
						Op_next[1] = Op_in;/*0 for load 1 for store*/;
						next_state = ENTRY2;
                    end else begin
                        busy_next[1] = busy[1];
                        addr_next[1] = addr[1];
                        Vi_next[1] = Vi[1];
                        Qi_next[1] = Qi[1];
                        next_state = ENTRY1;
                    end

					if(busy[2])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[2] =LS_result;
							Qi_next[2] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[2] = ADD1_result;
							Qi_next[2] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[2] = ADD2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = ADD3_result;
							Qi_next[2] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[2] = MUL1_result;
							Qi_next[2] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[2] = MUL2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = cdb9;
							Qi_next[2] = 0;
						end else begin
							Vi_next[2] = 0;
							Qi_next[2] = Qi[0];
						end
					end 
					else begin
						Vi_next[2] = 0;
						Qi_next[2] = 0;
					end

					if(busy[3])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[3] =LS_result;
							Qi_next[3] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[3] = ADD1_result;
							Qi_next[3] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[3] = ADD2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = ADD3_result;
							Qi_next[3] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[3] = MUL1_result;
							Qi_next[3] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[3] = MUL2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = cdb9;
							Qi_next[3] = 0;
						end else begin
							Vi_next[3] = 0;
							Qi_next[3] = Qi[0];
						end
					end 
					else begin
						Vi_next[3] = 0;
						Qi_next[3] = 0;
					end

					if(busy[4])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[4] =LS_result;
							Qi_next[4] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[4] = ADD1_result;
							Qi_next[4] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[4] = ADD2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = ADD3_result;
							Qi_next[4] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[4] = MUL1_result;
							Qi_next[4] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[4] = MUL2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = cdb9;
							Qi_next[4] = 0;
						end else begin
							Vi_next[4] = 0;
							Qi_next[4] = Qi[0];
						end
					end 
					else begin
						Vi_next[4] = 0;
						Qi_next[4] = 0;
					end

					if(busy[5])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[5] =LS_result;
							Qi_next[5] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[5] = ADD1_result;
							Qi_next[5] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[5] = ADD2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = ADD3_result;
							Qi_next[5] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[5] = MUL1_result;
							Qi_next[5] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[5] = MUL2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = cdb9;
							Qi_next[5] = 0;
						end else begin
							Vi_next[5] = 0;
							Qi_next[5] = Qi[0];
						end
					end 
					else begin
						Vi_next[5] = 0;
						Qi_next[5] = 0;
					end
                end

//TODO: complete the logic for rest of the states
		ENTRY2: begin
					busy_next[0] = busy[0];
					busy_next[1] = busy[1];
					busy_next[3] = busy[3];
					busy_next[4] = busy[4];
					busy_next[5] = busy[5];
					addr_next[0] = addr[0];
					addr_next[1] = addr[1];
					addr_next[3] = addr[3];
					addr_next[4] = addr[4];
					addr_next[5] = addr[5];
					//Vi_next[0] = (Q[0]==0)?Vi[0]:/*use Q[0]and the valid for that input as selece*/;

					if(busy[0])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[0] =LS_result;
							Qi_next[0] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[0] = ADD1_result;
							Qi_next[0] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[0] = ADD2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = ADD3_result;
							Qi_next[0] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[0] = MUL1_result;
							Qi_next[0] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[0] = MUL2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = cdb9;
							Qi_next[0] = 0;
						end else begin
							Vi_next[0] = 0;
							Qi_next[0] = Qi[0];
						end
					end 
					else begin
						Vi_next[0] = 0;
						Qi_next[0] = 0;
					end

					if(busy[1])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[1] =LS_result;
							Qi_next[1] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[1] = ADD1_result;
							Qi_next[1] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[1] = ADD2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = ADD3_result;
							Qi_next[1] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[1] = MUL1_result;
							Qi_next[1] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[1] = MUL2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = cdb9;
							Qi_next[1] = 0;
						end else begin
							Vi_next[1] = 0;
							Qi_next[1] = Qi[0];
						end
					end 
					else begin
						Vi_next[1] = 0;
						Qi_next[1] = 0;
					end

                    if(sel)begin
                        busy_next[2] = 1;
                        addr_next[2] = offset+rs;
						Vi_next[2] = Vi_in;
                        Qi_next[2] = Qi_in;
						Op_next[2] = Op_in;/*0 for load 1 for store*/;
						next_state = ENTRY3;
                    end else begin
                        busy_next[2] = busy[2];
                        addr_next[2] = addr[2];
                        Vi_next[2] = Vi[2];
                        Qi_next[2] = Qi[2];
                        next_state = ENTRY2;
                    end

					if(busy[3])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[3] =LS_result;
							Qi_next[3] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[3] = ADD1_result;
							Qi_next[3] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[3] = ADD2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = ADD3_result;
							Qi_next[3] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[3] = MUL1_result;
							Qi_next[3] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[3] = MUL2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = cdb9;
							Qi_next[3] = 0;
						end else begin
							Vi_next[3] = 0;
							Qi_next[3] = Qi[0];
						end
					end 
					else begin
						Vi_next[3] = 0;
						Qi_next[3] = 0;
					end

					if(busy[4])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[4] =LS_result;
							Qi_next[4] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[4] = ADD1_result;
							Qi_next[4] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[4] = ADD2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = ADD3_result;
							Qi_next[4] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[4] = MUL1_result;
							Qi_next[4] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[4] = MUL2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = cdb9;
							Qi_next[4] = 0;
						end else begin
							Vi_next[4] = 0;
							Qi_next[4] = Qi[0];
						end
					end 
					else begin
						Vi_next[4] = 0;
						Qi_next[4] = 0;
					end

					if(busy[5])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[5] =LS_result;
							Qi_next[5] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[5] = ADD1_result;
							Qi_next[5] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[5] = ADD2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = ADD3_result;
							Qi_next[5] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[5] = MUL1_result;
							Qi_next[5] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[5] = MUL2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = cdb9;
							Qi_next[5] = 0;
						end else begin
							Vi_next[5] = 0;
							Qi_next[5] = Qi[0];
						end
					end 
					else begin
						Vi_next[5] = 0;
						Qi_next[5] = 0;
					end
                end

		ENTRY3: begin
					busy_next[0] = busy[0];
					busy_next[1] = busy[1];
					busy_next[2] = busy[2];
					busy_next[4] = busy[4];
					busy_next[5] = busy[5];
					addr_next[0] = addr[0];
					addr_next[1] = addr[1];
					addr_next[2] = addr[2];
					addr_next[4] = addr[4];
					addr_next[5] = addr[5];
					//Vi_next[0] = (Q[0]==0)?Vi[0]:/*use Q[0]and the valid for that input as selece*/;

					if(busy[0])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[0] =LS_result;
							Qi_next[0] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[0] = ADD1_result;
							Qi_next[0] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[0] = ADD2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = ADD3_result;
							Qi_next[0] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[0] = MUL1_result;
							Qi_next[0] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[0] = MUL2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = cdb9;
							Qi_next[0] = 0;
						end else begin
							Vi_next[0] = 0;
							Qi_next[0] = Qi[0];
						end
					end 
					else begin
						Vi_next[0] = 0;
						Qi_next[0] = 0;
					end

					if(busy[1])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[1] =LS_result;
							Qi_next[1] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[1] = ADD1_result;
							Qi_next[1] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[1] = ADD2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = ADD3_result;
							Qi_next[1] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[1] = MUL1_result;
							Qi_next[1] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[1] = MUL2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = cdb9;
							Qi_next[1] = 0;
						end else begin
							Vi_next[1] = 0;
							Qi_next[1] = Qi[0];
						end
					end 
					else begin
						Vi_next[1] = 0;
						Qi_next[1] = 0;
					end

					if(busy[2])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[2] =LS_result;
							Qi_next[2] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[2] = ADD1_result;
							Qi_next[2] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[2] = ADD2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = ADD3_result;
							Qi_next[2] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[2] = MUL1_result;
							Qi_next[2] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[2] = MUL2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = cdb9;
							Qi_next[2] = 0;
						end else begin
							Vi_next[2] = 0;
							Qi_next[2] = Qi[0];
						end
					end 
					else begin
						Vi_next[2] = 0;
						Qi_next[2] = 0;
					end

                    if(sel)begin
                        busy_next[3] = 1;
                        addr_next[3] = offset+rs;
						Vi_next[3] = Vi_in;
                        Qi_next[3] = Qi_in;
						Op_next[3] = Op_in;/*0 for load 1 for store*/;
						next_state = ENTRY4;
                    end else begin
                        busy_next[3] = busy[3];
                        addr_next[3] = addr[3];
                        Vi_next[3] = Vi[3];
                        Qi_next[3] = Qi[3];
                        next_state = ENTRY3;
                    end

					if(busy[4])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[4] =LS_result;
							Qi_next[4] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[4] = ADD1_result;
							Qi_next[4] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[4] = ADD2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = ADD3_result;
							Qi_next[4] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[4] = MUL1_result;
							Qi_next[4] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[4] = MUL2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = cdb9;
							Qi_next[4] = 0;
						end else begin
							Vi_next[4] = 0;
							Qi_next[4] = Qi[0];
						end
					end 
					else begin
						Vi_next[4] = 0;
						Qi_next[4] = 0;
					end

					if(busy[5])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[5] =LS_result;
							Qi_next[5] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[5] = ADD1_result;
							Qi_next[5] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[5] = ADD2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = ADD3_result;
							Qi_next[5] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[5] = MUL1_result;
							Qi_next[5] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[5] = MUL2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = cdb9;
							Qi_next[5] = 0;
						end else begin
							Vi_next[5] = 0;
							Qi_next[5] = Qi[0];
						end
					end 
					else begin
						Vi_next[5] = 0;
						Qi_next[5] = 0;
					end
                end

		ENTRY4: begin
					busy_next[0] = busy[0];
					busy_next[1] = busy[1];					
					busy_next[2] = busy[2];
					busy_next[3] = busy[3];
					busy_next[5] = busy[5];
					addr_next[0] = addr[0];
					addr_next[1] = addr[1];
					addr_next[2] = addr[2];
					addr_next[3] = addr[3];
					addr_next[5] = addr[5];
					//Vi_next[0] = (Q[0]==0)?Vi[0]:/*use Q[0]and the valid for that input as selece*/;

					if(busy[0])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[0] =LS_result;
							Qi_next[0] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[0] = ADD1_result;
							Qi_next[0] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[0] = ADD2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = ADD3_result;
							Qi_next[0] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[0] = MUL1_result;
							Qi_next[0] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[0] = MUL2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = cdb9;
							Qi_next[0] = 0;
						end else begin
							Vi_next[0] = 0;
							Qi_next[0] = Qi[0];
						end
					end 
					else begin
						Vi_next[0] = 0;
						Qi_next[0] = 0;
					end

					if(busy[1])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[1] =LS_result;
							Qi_next[1] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[1] = ADD1_result;
							Qi_next[1] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[1] = ADD2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = ADD3_result;
							Qi_next[1] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[1] = MUL1_result;
							Qi_next[1] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[1] = MUL2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = cdb9;
							Qi_next[1] = 0;
						end else begin
							Vi_next[1] = 0;
							Qi_next[1] = Qi[0];
						end
					end 
					else begin
						Vi_next[1] = 0;
						Qi_next[1] = 0;
					end

					if(busy[2])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[2] =LS_result;
							Qi_next[2] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[2] = ADD1_result;
							Qi_next[2] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[2] = ADD2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = ADD3_result;
							Qi_next[2] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[2] = MUL1_result;
							Qi_next[2] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[2] = MUL2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = cdb9;
							Qi_next[2] = 0;
						end else begin
							Vi_next[2] = 0;
							Qi_next[2] = Qi[0];
						end
					end

					if(busy[3])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[3] =LS_result;
							Qi_next[3] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[3] = ADD1_result;
							Qi_next[3] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[3] = ADD2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = ADD3_result;
							Qi_next[3] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[3] = MUL1_result;
							Qi_next[3] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[3] = MUL2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = cdb9;
							Qi_next[3] = 0;
						end else begin
							Vi_next[3] = 0;
							Qi_next[3] = Qi[0];
						end
					end 
					else begin
						Vi_next[3] = 0;
						Qi_next[3] = 0;
					end

                    if(sel)begin
                        busy_next[4] = 1;
                        addr_next[4] = offset+rs;
						Vi_next[4] = Vi_in;
                        Qi_next[4] = Qi_in;
						Op_next[4] = Op_in;/*0 for load 1 for store*/;
						next_state = ENTRY5;
                    end else begin
                        busy_next[4] = busy[4];
                        addr_next[4] = addr[4];
                        Vi_next[4] = Vi[4];
                        Qi_next[4] = Qi[4];
                        next_state = ENTRY4;
                    end

					if(busy[5])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[5] =LS_result;
							Qi_next[5] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[5] = ADD1_result;
							Qi_next[5] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[5] = ADD2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = ADD3_result;
							Qi_next[5] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[5] = MUL1_result;
							Qi_next[5] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[5] = MUL2_result;
							Qi_next[5] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[5] = cdb9;
							Qi_next[5] = 0;
						end else begin
							Vi_next[5] = 0;
							Qi_next[5] = Qi[0];
						end
					end 
					else begin
						Vi_next[5] = 0;
						Qi_next[5] = 0;
					end
                end

		ENTRY5: begin
					busy_next[0] = busy[0];
					busy_next[1] = busy[1];
					busy_next[2] = busy[2];
					busy_next[3] = busy[3];
					busy_next[4] = busy[4];
					addr_next[0] = addr[0];
					addr_next[1] = addr[1];
					addr_next[2] = addr[2];
					addr_next[3] = addr[3];
					addr_next[4] = addr[4];
					//Vi_next[0] = (Q[0]==0)?Vi[0]:/*use Q[0]and the valid for that input as selece*/;

					if(busy[0])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[0] =LS_result;
							Qi_next[0] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[0] = ADD1_result;
							Qi_next[0] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[0] = ADD2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = ADD3_result;
							Qi_next[0] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[0] = MUL1_result;
							Qi_next[0] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[0] = MUL2_result;
							Qi_next[0] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[0] = cdb9;
							Qi_next[0] = 0;
						end else begin
							Vi_next[0] = 0;
							Qi_next[0] = Qi[0];
						end
					end 
					else begin
						Vi_next[0] = 0;
						Qi_next[0] = 0;
					end

					if(busy[1])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[1] =LS_result;
							Qi_next[1] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[1] = ADD1_result;
							Qi_next[1] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[1] = ADD2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = ADD3_result;
							Qi_next[1] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[1] = MUL1_result;
							Qi_next[1] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[1] = MUL2_result;
							Qi_next[1] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[1] = cdb9;
							Qi_next[1] = 0;
						end else begin
							Vi_next[1] = 0;
							Qi_next[1] = Qi[0];
						end
					end 
					else begin
						Vi_next[1] = 0;
						Qi_next[1] = 0;
					end

					if(busy[2])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[2] =LS_result;
							Qi_next[2] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[2] = ADD1_result;
							Qi_next[2] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[2] = ADD2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = ADD3_result;
							Qi_next[2] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[2] = MUL1_result;
							Qi_next[2] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[2] = MUL2_result;
							Qi_next[2] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[2] = cdb9;
							Qi_next[2] = 0;
						end else begin
							Vi_next[2] = 0;
							Qi_next[2] = Qi[0];
						end
					end

					if(busy[3])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[3] =LS_result;
							Qi_next[3] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[3] = ADD1_result;
							Qi_next[3] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[3] = ADD2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = ADD3_result;
							Qi_next[3] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[3] = MUL1_result;
							Qi_next[3] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[3] = MUL2_result;
							Qi_next[3] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[3] = cdb9;
							Qi_next[3] = 0;
						end else begin
							Vi_next[3] = 0;
							Qi_next[3] = Qi[0];
						end
					end 
					else begin
						Vi_next[3] = 0;
						Qi_next[3] = 0;
					end

					if(busy[4])begin
						if(Qi[0]==LS_idx&&LS_valid)
							Vi_next[4] =LS_result;
							Qi_next[4] = 0;
						end else if(ADD1_valid&&Q[0]==7)begin
							Vi_next[4] = ADD1_result;
							Qi_next[4] = 0;
						end else if(ADD2_valid&&Q[0]==8)begin
							Vi_next[4] = ADD2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = ADD3_result;
							Qi_next[4] = 0;
						end else if(MUL1_valid&&Q[0]==10)begin
							Vi_next[4] = MUL1_result;
							Qi_next[4] = 0;
						end else if(MUL2_valid&&Q[0]==11)begin
							Vi_next[4] = MUL2_result;
							Qi_next[4] = 0;
						end else if(ADD3_valid&&Q[0]==9)begin
							Vi_next[4] = cdb9;
							Qi_next[4] = 0;
						end else begin
							Vi_next[4] = 0;
							Qi_next[4] = Qi[0];
						end
					end 
					else begin
						Vi_next[4] = 0;
						Qi_next[4] = 0;
					end

                    if(sel)begin
                        busy_next[5] = 1;
                        addr_next[5] = offset+rs;
						Vi_next[5] = Vi_in;
                        Qi_next[5] = Qi_in;
						Op_next[5] = Op_in;/*0 for load 1 for store*/;
						next_state = ENTRY0;
                    end else begin
                        busy_next[5] = busy[5];
                        addr_next[5] = addr[5];
                        Vi_next[5] = Vi[5];
                        Qi_next[5] = Qi[5];
                        next_state = ENTRY4;
                    end
				end
	endcase
end

//head logic
//use a FSM to keep track of the state of the head and control busy values and
//head values
localparam IDLE＝0, WAIT=1, EXE=2;
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
					if(sel)begin
						next_state_o = WAIT;
					end
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
						next_state_o = WAIT;
					end else begin
						head_next = head;
						next_state_o = EXE;
					end		
				end
	endcase
end
//output logic
//use head value to determine where  output valus come from and validity
assign rd_addr = address[head];
assign wr_addr = address[head];
assign wen;
assign data_out;
assign valid_out0 = (head==0&&exe_count==0)1:0;
assign valid_out1 = (head==1&&exe_count==0)1:0;
assign valid_out2 = (head==2&&exe_count==0)1:0;
assign valid_out3 = (head==3&&exe_count==0)1:0;
assign valid_out4 = (head==4&&exe_count==0)1:0;
assign valid_out5 = (head==5&&exe_count==0)1:0;

//one valid for each entry

endmodule
