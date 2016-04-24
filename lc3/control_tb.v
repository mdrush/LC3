module control_tb;
    reg clk;
    reg [15:0] IR;
    reg R;
    reg N;
    reg Z;
    reg P;

  control CONTROL(.clk(clk),
    .IR(IR),
    .R(R),
    .N(N),
    .Z(Z),
    .P(P));

initial begin
N = 0;
Z = 0;
P = 0;
$dumpfile("dumpcontrol.vcd");
$dumpvars(0, control_tb);
R = 1;
clk = 0;
//IR = 16'b00010000010000;
IR = 16'b0001111101000100; //ADD R7, R5, R4
//CONTROL.global = 16'h0F0F;

//N = 1;
//Z = 1;
//P = 1;
$display("%b", CONTROL.controlsig[CONTROL.state]);

toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);
toggle_clk;
$display("%h", CONTROL.ALU.OUT);
$display("%b", CONTROL.controlsig[CONTROL.state]);

end

task toggle_clk;
    begin
        #10 clk = ~clk; // delay 10
        #10 clk = ~clk;
    end
endtask

endmodule