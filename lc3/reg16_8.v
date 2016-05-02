module reg16_8(clk, ld_reg, SR1, SR1_OUT, SR2, SR2_OUT, DR, global);

    reg [15:0] regs [0:7]; // Eight 16-bit registers

    input clk;
    input ld_reg;

     // control signals
    input [2:0] SR1;
    input [2:0] SR2;
    input [2:0] DR; // select register to write to

    output wire [15:0] SR1_OUT; // page 143
    output wire [15:0] SR2_OUT;

    input [15:0] global;

    integer i;
initial begin
    for (i = 0; i < 8; i = i + 1)
        regs[i] = 16'h0000;
end

assign SR1_OUT = regs[SR1];
assign SR2_OUT = regs[SR2];

 always @(posedge clk) begin

        if (ld_reg)
           regs[DR] <= global;

end
endmodule