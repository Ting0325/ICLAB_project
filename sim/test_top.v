module test_top;

parameter PERIOD = 10;

// input
reg clk;
reg rst_n;
reg [31:0] instn;
reg [18:0] i_addr;
reg i_wea;
reg start;
// output
wire EXE_alu_overflow;

top top(
.clk(clk),
.rst_n(rst_n),
.i_instruction(instn),
.i_addr(i_addr),
.i_wea(i_wea),
.start(start)
);



initial begin
  $fsdbDumpfile("project.fsdb");
  $fsdbDumpvars("+mda");
end

always #(PERIOD/2) clk = ~clk;

initial begin
  start = 0;
  clk = 0;
  rst_n = 1;
  #(PERIOD) rst_n = 0;
  #(PERIOD) rst_n = 1;
  #(1000000000*PERIOD) 
  $display("Simulation end by time out"); 
  $finish;
end


reg [31:0] instruction [0:5];
//reg [31:0] golden [0:31];
reg finish;
integer i, f_out;
initial begin
  instn = 0;
  finish = 0;
  $readmemb("instruction.txt", instruction);
  wait(rst_n==0);
  wait(rst_n==1);
  $display("loading instructions into i-cache");
  for(i=1; i<7; i=i+1)begin
    @(negedge clk)
      i_wea = 1;
      instn = instruction[i-1];
      $display("instruction #%d : %b",i-1,instn);
      i_addr = i;
    #(PERIOD);
  end
  $display("finishing loading %d instructions ,start pc",i-1);
  @(posedge clk)
   start  = 1;
     
  #(57*PERIOD) 
  $display("execute 57 cycles");
    $finish;
end

endmodule
