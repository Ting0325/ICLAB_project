module regfile
#(
  parameter dw = 32,      //data width
  parameter aw = 5        //regfile address width
)
(
  input               clk,
  input               rst_n,
  // Port Read 1
  input [aw-1:0]      read_addr1,
  output [dw-1:0]     read_data1,
  // Port Read 2
  input [aw-1:0]      read_addr2,
  output  [dw-1:0]    read_data2,
  // Port Write
  input [aw-1:0]      write_addr,
  input [dw-1:0]      write_data,
  //read,
  input               write
);

reg [dw-1:0] gpr [31:0];  //declare 32 32-bit general purpose register (gpr)

always@(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    gpr[0]  <= 32'd0;
    gpr[1]  <= 32'd1;
    gpr[2]  <= 32'd2;
    gpr[3]  <= 32'd3;
    gpr[4]  <= 32'd4;
    gpr[5]  <= 32'd5;
    gpr[6]  <= 32'd6;
    gpr[7]  <= 32'd7;
    gpr[8]  <= 32'd8;
    gpr[9]  <= 32'd9;
    gpr[10] <= 32'd10;
    gpr[11] <= 32'd11;
    gpr[12] <= 32'd12;
    gpr[13] <= 32'd13;
    gpr[14] <= 32'd14;
    gpr[15] <= 32'd15;
    gpr[16] <= 32'd16;
    gpr[17] <= 32'd17;
    gpr[18] <= 32'd18;
    gpr[19] <= 32'd19;
    gpr[20] <= 32'd20;
    gpr[21] <= 32'd21;
    gpr[22] <= 32'd22;
    gpr[23] <= 32'd23;
    gpr[24] <= 32'd24;
    gpr[25] <= 32'd25;
    gpr[26] <= 32'd26;
    gpr[27] <= 32'd27;
    gpr[28] <= 32'd28;
    gpr[29] <= 32'd29;
    gpr[30] <= 32'd30;
    gpr[31] <= 32'd31;
//    read_data1 <= 0;
//    read_data2 <= 0;
  end
  else if(write) begin
    gpr[write_addr] <= write_data;
//    read_data1 <= gpr[read_addr1];
//    read_data2 <= gpr[read_addr2];
  end
//  else begin
//    read_data1 <= gpr[read_addr1];
//    read_data2 <= gpr[read_addr2];
//  end

end
assign read_data1 = gpr[read_addr1];
assign read_data2 = gpr[read_addr2];
endmodule
