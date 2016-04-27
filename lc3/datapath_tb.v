`include "datapath.v"
module datapath_tb;
	reg clk;
	reg reset;


datapath DATAPATH(.clk(clk), .reset(reset));

initial begin
	$dumpfile("dumpdatapath.vcd");
	$dumpvars(0, datapath_tb);

	clk = 1;

	repeat(4) begin
		toggle_clk;
	end
	reset = 1;
	toggle_clk;
	reset = 0;
	repeat(50000) begin
		toggle_clk;
	end
end

always @(DATAPATH.REGFILE.regs[0] or DATAPATH.REGFILE.regs[1]) begin
	$display("IR: %h", DATAPATH.IR, " R0: %h", DATAPATH.REGFILE.regs[0],
		 " R1: %h", DATAPATH.REGFILE.regs[1]);
end

task toggle_clk;
    begin
        #10 clk = ~clk; // delay 10
        #10 clk = ~clk;
    end
endtask

endmodule