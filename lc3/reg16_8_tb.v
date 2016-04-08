module reg16_8_tb;
    reg clk;
    reg ld_reg;
    reg [2:0] SR1;
    reg [2:0] SR2;
    reg [2:0] DR; // select register to write to
    wire [15:0] SR1_OUT; // page 143
    wire [15:0] SR2_OUT;
    reg [15:0] global;

  reg16_8 REGFILE(.clk(clk),
    .ld_reg(ld_reg),
    .SR1(SR1),
    .SR2(SR2),
    .DR(DR),
    .SR1_OUT(SR1_OUT),
    .SR2_OUT(SR2_OUT),
    .global(global));

initial begin
$dumpfile("dumpreg.vcd");
$dumpvars(1, reg16_8_tb);

clk = 0;
SR1 = 3'b000;
SR2 = 3'b001;
global = 16'hF0F0;
DR = 3'b000;
ld_reg = 1;


$display("%h", SR1_OUT);
ld_reg = 0;
toggle_clk;
$display("%h", SR1_OUT);
SR2 = 3'b000;
toggle_clk;

end

task toggle_clk;
    begin
        #10 clk = ~clk; // delay 10
        #10 clk = ~clk;
    end
endtask

endmodule