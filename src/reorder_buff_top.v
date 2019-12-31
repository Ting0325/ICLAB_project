/* top module for the reorder buffers,logs incomming instructions as well as
 * their assigned reservation stations 
 * Both the designated reorder buffer entry and reservation are provided by
 * the instruction handler
 * Also outputs busy status of each reorder buffer entry to the instruction
 * handler to detect structral hazards
 *	
 *
 * */
module reorder_buff(
	input clk,
	input rst_n,
	input index_rb,//the assigned reorder buffer entry
	input index_rs,//the assigned reservation station
	input instruction,
	output busy0,
	output busy1,
	output busy2,
	output busy3,
	output busy4,
	output busy5,
	output busy6,
	output busy7,
	output reg commit_idx,
	output reg commit_data,
	output reg commit_valid,
	
);


wire sel0,sel1,sel2,sel3,sel4,sel5,sel6,sel7;
wire valid0,valid1,valid2,valid3,valid4,valid5,valid6,valid7;
wire dest0,dest1,dest2,dest3,dest4,dest5,dest6,dest7;
wire value0,value1,value2,value3,value4,value5,value6,value7;
wire wen0,wen1,wen2,wen3,wen4,wen5,wen6,wen7;
/* use a head vale to indicate which entry to commit:
 * in-order-commit
 *
 * */
reg head,head_next;
localparam HOLD = 0,ADVANCE = 1;
reg state,next_state;
always@(posedge clk)begin
	if(rst_n)begin 
		head <= 0 ;
	end else begin 
		head <= head_state;
	end
end

always@(*)begin
	case(head)
		0:	begin
				if(valid0)
					head_next = head;
				else
					head_next = head + 1;
			end
        1:  begin
                if(valid1)
                    head_next = head;
                else
                    head_next = head + 1;
            end
        2:  begin
                if(valid2)
                    head_next = head;
                else
                    head_next = head + 1;
            end
        3:  begin
                if(valid3)
                    head_next = head;
                else
                    head_next = head + 1;
            end
		4:  begin
                if(valid4)
                    head_next = head;
                else
                    head_next = head + 1;
            end
		5:  begin
                if(valid5)
                    head_next = head;
                else
                    head_next = head + 1;
            end
		6:  begin
                if(valid6)
                    head_next = head;
                else
                    head_next = head + 1;
            end
		7:  begin
                if(valid7)
                    head_next = head;
                else
                    head_next = 0;
            end

	endcase
end

assign sel0 = (index_rb==0)?1:0;
assign sel1 = (index_rb==1)?1:0;
assign sel2 = (index_rb==2)?1:0;
assign sel3 = (index_rb==3)?1:0;
assign sel4 = (index_rb==4)?1:0;
assign sel5 = (index_rb==5)?1:0;
assign sel6 = (index_rb==6)?1:0;
assign sel7 = (index_rb==7)?1:0;

//output logic
/* use the value of the head to select output from the corresponding 
 * reorder buffer
 * commit_idx,commit_data,commit_valid
 * 
 * */
always@(*)begin
	case(head)
		0:	commit_idx = dest0;
		1:  commit_idx = dest1;
		2:  commit_idx = dest2;
		3:  commit_idx = dest3;
		4:  commit_idx = dest4;
		5:  commit_idx = dest5;
		6:  commit_idx = dest6;
		7:  commit_idx = dest7;
	endcase 
end

always@(*)begin
    case(head)
        0:  commit_data = value0;
        1:  commit_data = value1;
        2:  commit_data = value2;
        3:  commit_data = value3;
        4:  commit_data = value4;
        5:  commit_data = value5;
        6:  commit_data = value6;
        7:  commit_data = value7;
    endcase
end

always@(*)begin
    case(head)
        0:  commit_valid = valid0;
        1:  commit_valid = valid1;
        2:  commit_valid = valid2;
        3:  commit_valid = valid3;
        4:  commit_valid = valid4;
        5:  commit_valid = valid5;
        6:  commit_valid = valid6;
        7:  commit_valid = valid7;
    endcase
end
//reorder buffer entries
reorder_buff_entry rb0(
	.clk(clk),
	.rst_n(rst_n),
	.sel(sel0),
	.from_rs_idx(index_rs),//this value is assigned by the instruction handler,allocating a reservation station for the incomming instruction
	.instruction_in(instruction),
	.dest(dest0),
	.valid(valid0),
	.value(value0),
	.dest(dest0),
	.wen(wen0),
	.busy(busy0)
);

reorder_buff_entry rb1(
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel1),
    .from_rs_idx(index_rs),
    .instruction_in(instruction),
    .dest(dest1),
    .valid(valid1),
    .value(value1),
    .dest(dest1),
    .wen(wen1),
    .busy(busy1)
);

reorder_buff_entry rb2(
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel2),
    .from_rs_idx(index_rs),
    .instruction_in(instruction),
    .dest(dest2),
    .valid(valid2),
    .value(value2),
    .dest(dest2),
    .wen(wen2),
    .busy(busy2)
);

reorder_buff_entry rb3(
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel3),
    .from_rs_idx(index_rs),
    .instruction_in(instruction),
    .dest(dest3),
    .valid(valid3),
    .value(value3),
    .dest(dest3),
    .wen(wen3),
    .busy(busy3)
);

reorder_buff_entry rb4(
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel1),
    .from_rs_idx(index_rs),
    .instruction_in(instruction),
    .dest(dest1),
    .valid(valid1),
    .value(value1),
    .dest(dest1),
    .wen(wen1),
    .busy(busy1)
);

reorder_buff_entry rb5(
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel1),
    .from_rs_idx(index_rs),
    .instruction_in(instruction),
    .dest(dest1),
    .valid(valid1),
    .value(value1),
    .dest(dest1),
    .wen(wen1),
    .busy(busy1)
);

reorder_buff_entry rb6(
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel1),
    .from_rs_idx(index_rs),
    .instruction_in(instruction),
    .dest(dest1),
    .valid(valid1),
    .value(value1),
    .dest(dest1),
    .wen(wen1),
    .busy(busy1)
);

reorder_buff_entry rb7(
    .clk(clk),
    .rst_n(rst_n),
    .sel(sel1),
    .from_rs_idx(index_rs),
    .instruction_in(instruction),
    .dest(dest1),
    .valid(valid1),
    .value(value1),
    .dest(dest1),
    .wen(wen1),
    .busy(busy1)
);

endmodule
