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

always @(*) begin
	if (!DATAPATH.MIO.MCR[15])
		$finish();
end

// always @(DATAPATH.IR) begin
// 	$display("IR: %h", DATAPATH.IR, " | R0: %h", DATAPATH.REGFILE.regs[0],
// 		 " | R1: %h", DATAPATH.REGFILE.regs[1],
// 		 " | R7: %h", DATAPATH.REGFILE.regs[7],
// 		 " | OS_KBSR: %h", DATAPATH.MIO.KBSR,
// 		 " | OS_KBDR: %h", DATAPATH.MIO.KBDR,
// 		 " | OS_DSR: %h", DATAPATH.MIO.DSR,
// 		 " | OS_DDR: %c", DATAPATH.MIO.DDR,
// 		 " | OS_MCR: %h", DATAPATH.MIO.MCR);
// end

always @(DATAPATH.MIO.DDR) begin
	$write("%c", DATAPATH.MIO.DDR);
	DATAPATH.MIO.DDR = 0;
end

// OS_KBSR	.FILL xFE00
// OS_KBDR	.FILL xFE02
// OS_DSR	.FILL xFE04
// OS_DDR	.FILL xFE06
// OS_MCR	.FILL xFFFE

task toggle_clk;
    begin
        #10 clk = ~clk; // delay 10
        #10 clk = ~clk;
    end
endtask

endmodule