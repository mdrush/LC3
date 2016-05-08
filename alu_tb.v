module alu_tb;
    reg [15:0] A;
    reg [15:0] B;
    reg [1:0] ALUK; // ADD, AND, NOT, PASSA
    wire [15:0] OUT;

  alu ALU(.A(A),
    .B(B),
    .ALUK(ALUK),
    .OUT(OUT));

initial begin
$dumpfile("dumpalu.vcd");
$dumpvars(1, alu_tb);

A = 16'hF0F0;
B = 16'h6060;
#10 ALUK = 0;
#10 ALUK = 1;
#10 ALUK = 2;
#10 ALUK = 3;
#10;

end
endmodule
