module inst_handler(
	input clk,
	input rst_n,
	input start,
    input [31:0] instruction,
	input [2:0] operation,

	input [2:0] ls_entry,
	input ls_full,
    input busy_add1,
    input busy_add2,
    input busy_add3,
    input busy_mul1,
    input busy_mul2,
    input busy_rb0,
	input busy_rb1,
	input busy_rb2,
	input busy_rb3,
	input busy_rb4,
	input busy_rb5,
	input busy_rb6,
	input busy_rb7,

	output reg [2:0] reorder_buffer_idx,
	output reg [3:0] reservation_station_idx,
	output reg struct_haz
);
reg [31:0] inst_count,inst_count_next;

localparam LOAD = 4, STORE = 5, ADD = 0, SUB = 1, MUL = 2, DIV = 3; 

/* each incomming instruction is assigned an id to determin which reorder
 * buffer to log it
 * ex id = 0 rob = 0
 *    id = 1 rob = 1
 *    id = 2 rob = 2
 *    id = 3 rob = 3
 *    id = 4 rob = 4
 *    id = 5 rob = 5
 *    id = 6 rob = 6
 *    id = 7 rob = 7
 *    id = 8 rob = 0
 *    id = 9 rob = 1
 *    id = 10 rob = 2
 *    ===> rob = id%8 
 *    ...
 * */
always@(posedge clk) begin
	if(~rst_n)begin 
		inst_count <= 0;
	end else begin 
		inst_count <= inst_count_next;
	end
end

//inst_count_idx
always@(*)begin
    if(start)begin
        if(struct_haz)
            inst_count_next = inst_count;
        else
            inst_count_next = inst_count + 1;
    end else begin
        inst_count_next = 0;
    end
end
//reorder_buffer_idx logic
always@(*)begin
	reorder_buffer_idx  =  inst_count%8;
end

always@(*)begin
    if(~start)begin
        struct_haz  = 0;
		reservation_station_idx = 12;
	end else if(busy_rb0 && busy_rb1 && busy_rb2 && busy_rb3 && busy_rb4 && busy_rb5 && busy_rb6 && busy_rb7)begin
		struct_haz  = 1;
		reservation_station_idx = 12;
	end else begin
        case(operation)	
            LOAD:	begin
                        if(ls_full)begin
                            struct_haz  = 1;
                            reservation_station_idx = 12;  // 12:garbage reservation station			
                        end else begin
                            struct_haz  = 0;
                            reservation_station_idx = ls_entry+1;//ex if ls_entyr = 0 ,reservation_station_idx = 1
                        end
                    
                    end
            STORE:	begin
                        if(ls_full)begin
                            struct_haz  = 1;
                            reservation_station_idx = 12;       
                        end else begin
                            struct_haz  = 0;
                            reservation_station_idx = ls_entry;
                        end

                    end
            ADD:	begin
                        if(!busy_add1)begin
                            struct_haz  = 0;
                            reservation_station_idx = 7; // 7:ADD1
                        end else if(!busy_add2)begin
                            struct_haz  = 0;
                            reservation_station_idx = 8; 
                        end else if(!busy_add3)begin
                            struct_haz  = 0;
                            reservation_station_idx = 9; // 9:ADD3
                        end else begin
                            struct_haz  = 1;
                            reservation_station_idx = 12;
                        end

                    end
            SUB:	begin
                        if(!busy_add1)begin
                            struct_haz  = 0;
                            reservation_station_idx = 7;
                        end else if(!busy_add2)begin
                            struct_haz  = 0;
                            reservation_station_idx = 8;
                        end else if(!busy_add3)begin
                            struct_haz  = 0;
                            reservation_station_idx = 9;
                        end else begin
                            struct_haz  = 1;
                            reservation_station_idx = 12;
                        end

                    end

            MUL:	begin
                        if(!busy_mul1)begin
                            struct_haz  = 0;
                            reservation_station_idx = 10; // 10:MUL1
                        end else if(!busy_mul2)begin
                            struct_haz  = 0;
                            reservation_station_idx = 11;
                        end else begin
                            struct_haz  = 1;
                            reservation_station_idx = 12;
                        end

                    end

            DIV:	begin
                        if(!busy_mul1)begin
                            struct_haz  = 0;
                            reservation_station_idx = 10;
                        end else if(!busy_mul2)begin
                            struct_haz  = 0;
                            reservation_station_idx = 11;
                        end else begin
                            struct_haz  = 1;
                            reservation_station_idx = 12;
                        end

                    end
        default:    begin
                        struct_haz  = 0;
                        reservation_station_idx = 12;
                    end
        endcase
	end
end


endmodule



















