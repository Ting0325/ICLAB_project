module i_cache #(
  parameter DATA_WIDTH=32,                 //width of data bus
  parameter ADDR_WIDTH=19                  //width of addresses buses
)(
  input      [DATA_WIDTH-1:0] dina,       //data to be written
  input      [ADDR_WIDTH-1:0] addrb,  //address for read operation
  input      [ADDR_WIDTH-1:0] addra, //address for write operation
  input                       wea,         //write enable signal
  input                       clk,  //clock signal for write operation
  output reg [DATA_WIDTH-1:0] doutb           //read data
);
    
  reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0]; // ** is exponentiation
    
  always @(posedge clk) begin //WRITE
    if (wea) begin 
      ram[addra] <= dina;
    end
  end
    
  always @(*) begin //READ
    doutb = ram[addrb];
  end
    
endmodule
