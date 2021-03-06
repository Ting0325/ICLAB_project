/* top module for the reorder buffers,logs incomming instructions as well as
 * their assigned reservation stations 
 * Both the designated reorder buffer entry and reservation are provided by
 * the instruction handler
 * Also outputs busy status of each reorder buffer entry to the instruction
 * handler to detect structral hazards
 *	
 *
 * */
module reorder_buff_top(
	input clk,
	input rst_n,
	input [2:0] index_rb,//the assigned reorder buffer entry
	input [3:0] index_rs,//the assigned reservation station
	input [31:0] instruction,
   //cdb
	input ADD1_valid,
	input [31:0] ADD1_result,
	input ADD2_valid,
	input [31:0] ADD2_result,
	input ADD3_valid,
	input [31:0] ADD3_result,
	input MULT1_valid,
	input [31:0] MULT1_result,
	input MULT2_valid,
	input [31:0] MULT2_result,
	input LS_valid,
	input [31:0] LS_value,
	input [2:0] LS_idx,


	output busy0,
	output busy1,
	output busy2,
	output busy3,
	output busy4,
	output busy5,
	output busy6,
	output busy7,
	output reg [4:0] commit_idx,   //dest
	output reg [31:0] commit_data,
	output reg commit_valid,
	output reg [3:0] commit_original_name 
	
);

//localparam entry_number_0 = 0 , entry_number_1 = 1, entry_number_2 = 2, entry_number_3 = 3;

wire [3:0] waiting_for0, waiting_for1, waiting_for2, waiting_for3, waiting_for4, waiting_for5, waiting_for6, waiting_for7;
reg valid0, valid1,  valid2, valid3, valid4, valid5, valid6, valid7;
reg [31:0] value0, value1,  value2, value3, value4, value5, value6, value7;

wire sel0,sel1,sel2,sel3,sel4,sel5,sel6,sel7;
wire [4:0] dest0,dest1,dest2,dest3,dest4,dest5,dest6,dest7;
wire wen0,wen1,wen2,wen3,wen4,wen5,wen6,wen7;

wire [3:0] from0, from1, from2, from3, from4, from5, from6, from7;

//
wire [31:0] val_buff0,val_buff1,val_buff2,val_buff3,val_buff4,val_buff5,val_buff6,val_buff7;

/* use a head vale to indicate which entry to commit:
 * in-order-commit
 *
 * */
reg [2:0] head,head_next;
localparam HOLD = 0,ADVANCE = 1;
reg state,next_state;
always@(posedge clk)begin
	if(~rst_n)begin 
		head <= 1 ;
	end else begin 
		head <= head_next;
	end
end

always@(*)begin
	case(head)
		0:	begin
				if(wen0)
					head_next = head+ 1;
				else
					head_next = head ;
			end
        1:  begin
                if(wen1)
                    head_next = head + 1;
                else
                    head_next = head;
            end
        2:  begin
                if(wen2)
                    head_next = head+ 1;
                else
                    head_next = head ;
            end
        3:  begin
                if(wen3)
                    head_next = head+ 1;
                else
                    head_next = head ;
            end
		4:  begin
                if(wen4)
                    head_next = head+ 1;
                else
                    head_next = head ;
            end
		5:  begin
                if(wen5)
                    head_next = head+ 1;
                else
                    head_next = head ;
            end
		6:  begin
                if(wen6)
                    head_next = head + 1;
                else
                    head_next = head ;
            end
		7:  begin
                if(wen7)
                    head_next = 0;
                else
                    head_next = head;
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
		0:	commit_original_name = waiting_for0;//from0;
		1:  commit_original_name = waiting_for1;//from1;
		2:  commit_original_name = waiting_for2;//from2;
		3:  commit_original_name = waiting_for3;//from3;
		4:  commit_original_name = waiting_for4;//from4;
		5:  commit_original_name = waiting_for5;//from5;
		6:  commit_original_name = waiting_for6;//from6;
		7:  commit_original_name = waiting_for7;//from7;
	endcase 
end



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


//in this version the action commit can be done as soon as possible(i.e if the head is waiting for the valid data on CDB)
//but if the value has to be buffered in the buffer and commmited later,the commit value will come from the corresponding head entry
always@(*)begin
    case(head)
        0:  commit_data = (~valid0&&wen0)?val_buff0:value0;//value0;
        1:  commit_data =(~valid1&&wen1)?val_buff1:value1;//value1;
        2:  commit_data = (~valid2&&wen2)?val_buff2:value2;//value2;
        3:  commit_data = (~valid3&&wen3)?val_buff3:value3;//value3;
        4:  commit_data = (~valid4&&wen4)?val_buff4:value4;//value4;
        5:  commit_data = (~valid5&&wen5)?val_buff5:value5;//value5;
        6:  commit_data = (~valid6&&wen6)?val_buff6:value6;//value6;
        7:  commit_data = (~valid7&&wen7)?val_buff7:value7;//value7;
    endcase
end

always@(*)begin
    case(head)
        0:  commit_valid = valid0 || wen0;
        1:  commit_valid = valid1 || wen1;
        2:  commit_valid = valid2 || wen2;
        3:  commit_valid = valid3 || wen3;
        4:  commit_valid = valid4 || wen4;
        5:  commit_valid = valid5 || wen5;
        6:  commit_valid = valid6 || wen6;
        7:  commit_valid = valid7 || wen7;
    endcase
end


//valid, value control for each reorder buffer entry
always@(*) begin  
	if((waiting_for0 == LS_idx+1)&&LS_valid)	begin  // waiting for load.store LS_idx = 0 ,waiting for = 1
		valid0 = 1;
		value0 = LS_value;
	end else if(waiting_for0==7 && ADD1_valid) begin
		valid0 = 1;
		value0 = ADD1_result;
	end else if(waiting_for0==8 && ADD2_valid) begin
		valid0 = 1;
		value0 = ADD2_result;
	end else if(waiting_for0==9 && ADD3_valid) begin
		valid0 = 1;
		value0 = ADD3_result;
	end else if(waiting_for0==10 && MULT1_valid) begin
		valid0 = 1;
		value0 = MULT1_result;
	end else if(waiting_for0==11 && MULT2_valid) begin
		valid0 = 1;
		value0 = MULT2_result;
	end else begin
		valid0 = 0;
		value0 = 0;
	end
end

always@(*) begin  
	if((waiting_for1 == LS_idx+1)&&LS_valid)	begin  // waiting for load.store
		valid1 = 1;
		value1 = LS_value;
	end else if(waiting_for1==7 && ADD1_valid) begin
		valid1 = 1;
		value1 = ADD1_result;
	end else if(waiting_for1==8 && ADD2_valid) begin
		valid1 = 1;
		value1 = ADD2_result;
	end else if(waiting_for1==9 && ADD3_valid) begin
		valid1 = 1;
		value1 = ADD3_result;
	end else if(waiting_for1==10 && MULT1_valid) begin
		valid1 = 1;
		value1 = MULT1_result;
	end else if(waiting_for1==11 && MULT2_valid) begin
		valid1 = 1;
		value1 = MULT2_result;
	end else begin
		valid1 = 0;
		value1 = 0;
	end
end

always@(*) begin  
	if((waiting_for2 == LS_idx+1)&&LS_valid)	begin  // waiting for load.store
		valid2 = 1;
		value2 = LS_value;
	end else if(waiting_for2==7 && ADD1_valid) begin
		valid2 = 1;
		value2 = ADD1_result;
	end else if(waiting_for2==8 && ADD2_valid) begin
		valid2 = 1;
		value2 = ADD2_result;
	end else if(waiting_for2==9 && ADD3_valid) begin
		valid2 = 1;
		value2 = ADD3_result;
	end else if(waiting_for2==10 && MULT1_valid) begin
		valid2 = 1;
		value2 = MULT1_result;
	end else if(waiting_for2==11 && MULT2_valid) begin
		valid2 = 1;
		value2 = MULT2_result;
	end else begin
		valid2 = 0;
		value2 = 0;
	end 
end

always@(*) begin  
	if((waiting_for3 == LS_idx+1)&&LS_valid)	begin  // waiting for load.store
		valid3 = 1;
		value3 = LS_value;
	end else if(waiting_for3==7 && ADD1_valid) begin
		valid3 = 1;
		value3 = ADD1_result;
	end else if(waiting_for3==8 && ADD2_valid) begin
		valid3 = 1;
		value3 = ADD2_result;
	end else if(waiting_for3==9 && ADD3_valid) begin
		valid3 = 1;
		value3 = ADD3_result;
	end else if(waiting_for3==10 && MULT1_valid) begin
		valid3 = 1;
		value3 = MULT1_result;
	end else if(waiting_for3==11 && MULT2_valid) begin
		valid3 = 1;
		value3 = MULT2_result;
	end else begin
		valid3 = 0;
		value3 = 0;
	end 
end

always@(*) begin  
	if((waiting_for4 == LS_idx+1)&&LS_valid)	begin  // waiting for load.store
		valid4 = 1;
		value4 = LS_value;
	end else if(waiting_for4==7 && ADD1_valid) begin
		valid4 = 1;
		value4 = ADD1_result;
	end else if(waiting_for4==8 && ADD2_valid) begin
		valid4 = 1;
		value4 = ADD2_result;
	end else if(waiting_for4==9 && ADD3_valid) begin
		valid4 = 1;
		value4 = ADD3_result;
	end else if(waiting_for4==10 && MULT1_valid) begin
		valid4 = 1;
		value4 = MULT1_result;
	end else if(waiting_for4==11 && MULT2_valid) begin
		valid4 = 1;
		value4 = MULT2_result;
	end else begin
		valid4 = 0;
		value4 = 0;
	end 
end

always@(*) begin  
	if((waiting_for5 == LS_idx +1)&&LS_valid)	begin  // waiting for load.store
		valid5 = 1;
		value5 = LS_value;
	end else if(waiting_for5==7 && ADD1_valid) begin
		valid5 = 1;
		value5 = ADD1_result;
	end else if(waiting_for5==8 && ADD2_valid) begin
		valid5 = 1;
		value5 = ADD2_result;
	end else if(waiting_for5==9 && ADD3_valid) begin
		valid5 = 1;
		value5 = ADD3_result;
	end else if(waiting_for5==10 && MULT1_valid) begin
		valid5 = 1;
		value5 = MULT1_result;
	end else if(waiting_for5==11 && MULT2_valid) begin
		valid5 = 1;
		value5 = MULT2_result;
	end else begin
		valid5 = 0;
		value5 = 0;
	end 
end

always@(*) begin  
	if((waiting_for6 == LS_idx+1)&&LS_valid)	begin  // waiting for load.store
		valid6 = 1;
		value6 = LS_value;
	end else if(waiting_for6==7 && ADD1_valid) begin
		valid6 = 1;
		value6 = ADD1_result;
	end else if(waiting_for6==8 && ADD2_valid) begin
		valid6 = 1;
		value6 = ADD2_result;
	end else if(waiting_for6==9 && ADD3_valid) begin
		valid6 = 1;
		value6 = ADD3_result;
	end else if(waiting_for6==10 && MULT1_valid) begin
		valid6 = 1;
		value6 = MULT1_result;
	end else if(waiting_for6==11 && MULT2_valid) begin
		valid6 = 1;
		value6 = MULT2_result;
	end else begin
		valid6 = 0;
		value6 = 0;
	end 
end

always@(*) begin  
	if((waiting_for7 == LS_idx+1)&&LS_valid)	begin  // waiting for load.store
		valid7 = 1;
		value7 = LS_value;
	end else if(waiting_for7==7 && ADD1_valid) begin
		valid7 = 1;
		value7 = ADD1_result;
	end else if(waiting_for7==8 && ADD2_valid) begin
		valid7 = 1;
		value7 = ADD2_result;
	end else if(waiting_for7==9 && ADD3_valid) begin
		valid7 = 1;
		value7 = ADD3_result;
	end else if(waiting_for7==10 && MULT1_valid) begin
		valid7 = 1;
		value7 = MULT1_result;
	end else if(waiting_for7==11 && MULT2_valid) begin
		valid7 = 1;
		value7 = MULT2_result;
	end else begin
		valid7 = 0;
		value7 = 0;
	end 
end





//reorder buffer entries
reorder_buff_entry #(
	.entry_number(0)
)
rb0
(
	.clk(clk),
	.rst_n(rst_n),
	.sel(sel0),
	.from_rs_idx(index_rs),//this value is assigned by the instruction handler,allocating a reservation station for the incomming instruction
	.instruction_in(instruction),
	.valid(valid0), // incoming data from cdb is valid, determinded by index_rs
	.value(value0), // value from cdb 
	.head(head),
	.dest(dest0),   //output for renaming table
	.wen(wen0),
	.busy(busy0),
	.waiting_for(waiting_for0),
	.val(val_buff0)
);

reorder_buff_entry #(
	.entry_number(1)
)
rb1
(
	.clk(clk),
	.rst_n(rst_n),
	.sel(sel1),
	.from_rs_idx(index_rs),
	.instruction_in(instruction),
	.valid(valid1), 
	.value(value1), 
	.head(head),
	.dest(dest1),   
	.wen(wen1),
	.busy(busy1),
	.waiting_for(waiting_for1),
	.val(val_buff1)
);

reorder_buff_entry #(
	.entry_number(2)
)
rb2
(
	.clk(clk),
	.rst_n(rst_n),
	.sel(sel2),
	.from_rs_idx(index_rs),
	.instruction_in(instruction),
	.valid(valid2), 
	.value(value2), 
	.head(head),
	.dest(dest2),   
	.wen(wen2),
	.busy(busy2),
	.waiting_for(waiting_for2),
	.val(val_buff2)
);

reorder_buff_entry #(
	.entry_number(3)
)
rb3
(
	.clk(clk),
	.rst_n(rst_n),
	.sel(sel3),
	.from_rs_idx(index_rs),
	.instruction_in(instruction),
	.valid(valid3), 
	.value(value3), 
	.head(head),
	.dest(dest3),   
	.wen(wen3),
	.busy(busy3),
	.waiting_for(waiting_for3),
	.val(val_buff3)
);

reorder_buff_entry #(
	.entry_number(4)
)
rb4
(
	.clk(clk),
	.rst_n(rst_n),
	.sel(sel4),
	.from_rs_idx(index_rs),
	.instruction_in(instruction),
	.valid(valid4), 
	.value(value4), 
	.head(head),
	.dest(dest4),   
	.wen(wen4),
	.busy(busy4),
	.waiting_for(waiting_for4),
	.val(val_buff4)
);

reorder_buff_entry #(
	.entry_number(5)
)
rb5
(
	.clk(clk),
	.rst_n(rst_n),
	.sel(sel5),
	.from_rs_idx(index_rs),
	.instruction_in(instruction),
	.valid(valid5), 
	.value(value5), 
	.head(head),
	.dest(dest5),   
	.wen(wen5),
	.busy(busy5),
	.waiting_for(waiting_for5),
	.val(val_buff5)
);

reorder_buff_entry #(
   .entry_number(6)
)
rb6
(
	.clk(clk),
	.rst_n(rst_n),
	.sel(sel6),
	.from_rs_idx(index_rs),
	.instruction_in(instruction),
	.valid(valid6), 
	.value(value6), 
	.head(head),
	.dest(dest6),   
	.wen(wen6),
	.busy(busy6),
	.waiting_for(waiting_for6),
	.val(val_buff6)
);

reorder_buff_entry #(
   .entry_number(7)
)
rb7
(
	.clk(clk),
	.rst_n(rst_n),
	.sel(sel7),
	.from_rs_idx(index_rs),
	.instruction_in(instruction),
	.valid(valid7), 
	.value(value7), 
	.head(head),
	.dest(dest7),   
	.wen(wen7),
	.busy(busy7),
	.waiting_for(waiting_for7),
	.val(val_buff7)
);

endmodule
