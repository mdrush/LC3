// Testbench
module microsequencer_tb;

  reg clk;
  reg [2:0] cond;
  wire [5:0] controlst;
  output reg [5:0] J;
  output reg INT;
  output reg R; //end of mem operation
  output reg [15:11] IR; //addressing mode (user subroutine)
  output reg BEN; //branch
  output reg PSR; //supervisor or user mode
  output reg IRD;

  microsequencer MICROSEQUENCER(.INT(INT),
          .R(R),
          .IR(IR),
          .BEN(BEN),
          .PSR(PSR),
          .cond(cond),
          .controlst(controlst),
          .J(J),
          .IRD(IRD));
  
initial begin
$dumpfile("microsequencer_dump.vcd");
$dumpvars(1, microsequencer_tb);

clk = 0;
IR[15:12] = 4'b1101;
J = 6'b000000;

INT = 1;
cond = 3'b011;
toggle_clk;
toggle_clk;
INT = 0;
cond = 3'b011;
toggle_clk;
toggle_clk;

R = 1;
cond = 3'b001;
toggle_clk;
toggle_clk;
R = 0;
cond = 3'b001;
toggle_clk;
toggle_clk;

IR[11] = 1;
cond = 3'b010;
toggle_clk;
toggle_clk;
IR[11] = 0;
cond = 3'b010;
toggle_clk;
toggle_clk;

IRD = 1;

BEN = 1;
cond = 3'b100;
toggle_clk;
toggle_clk;
BEN = 0;
cond = 3'b100;
toggle_clk;
toggle_clk;


PSR = 1;
cond = 3'b101;
toggle_clk;
toggle_clk;
PSR = 0;
cond = 3'b101;
toggle_clk;
toggle_clk;

end
  
task toggle_clk;
  begin
    #10 clk = ~clk;
    #10 clk = ~clk;
  end
endtask
  
endmodule