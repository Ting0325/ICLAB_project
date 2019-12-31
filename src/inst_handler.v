module inst_handler(
	input clk,
	input rst_n,
	input instruction,
	input operation,
/*	input busy_ls0,
	input busy_ls1,
	input busy_ls2,
	input busy_ls3,
	input busy_ls4,
	input busy_ls5,*/
	input ls_entry,
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


	output reg reorder_buffer_idx,
	output reg reservation_station_idx,
	output reg struct_haz
);
reg inst_count,inst_count_next;

assign struct_haz
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
always@(posedge clk){
	if(~rst_n)begin 
		inst_count <= 0;
	end else begin 
		inst_count <= inst_count_next;
	end
}
always@(*)begin
	reorder_buffer_idx  =  inst_count%8;
end

always@(*)begin
	if(busy_rb0&&busy_rb1&&busy_rb2&&busy_rb3&&busy_rb4&&busy_rb5&&busy_rb6&&busy_rb7)begin
		struct_haz  = 1;
		reservation_station_idx = 11;
	end else begin
	case(operation)	
		LOAD:	begin
					if(ls_full)begin
						struct_haz  = 1;
						reservation_station_idx = 11;						
					end else begin
						struct_haz  = 0;
						reservation_station_idx = ls_entry;
					end
				
				end
		STORE:	begin
                    if(ls_full)begin
                        struct_haz  = 1;
                        reservation_station_idx = 11;       
                    end else begin
                        struct_haz  = 0;
                        reservation_station_idx = ls_entry;
                    end

                end
		ADD:	begin
                    if(!busy_add1)begin
                        struct_haz  = 0;
                        reservation_station_idx = 6;
					end else if(!busy_add2)begin
       					struct_haz  = 0;
                        reservation_station_idx = 7;
					end else if(!busy_add3)begin
                        struct_haz  = 0;
                        reservation_station_idx = 8;
                    end else begin
                        struct_haz  = 1;
                        reservation_station_idx = 11;
                    end

                end
		SUB:	begin
                    if(!busy_add1)begin
                        struct_haz  = 0;
                        reservation_station_idx = 6;
                    end else if(!busy_add2)begin
                        struct_haz  = 0;
                        reservation_station_idx = 7;
                    end else if(!busy_add3)begin
                        struct_haz  = 0;
                        reservation_station_idx = 8;
                    end else begin
                        struct_haz  = 1;
                        reservation_station_idx = 11;
                    end

                end

		MUL:	begin
                    if(!busy_mul1)begin
                        struct_haz  = 0;
                        reservation_station_idx = 9;
                    end else if(!busy_mul1)begin
                        struct_haz  = 0;
                        reservation_station_idx = 10;
                    end else begin
                        struct_haz  = 1;
                        reservation_station_idx = 11;
                    end

                end

		DIV:	begin
                    if(!busy_mul1)begin
                        struct_haz  = 0;
                        reservation_station_idx = 9;
                    end else if(!busy_mul1)begin
                        struct_haz  = 0;
                        reservation_station_idx = 10;
                    end else begin
                        struct_haz  = 1;
                        reservation_station_idx = 11;
                    end

                end
	endcase
	end
end


endmodule



















