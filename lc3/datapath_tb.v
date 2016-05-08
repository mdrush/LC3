`include "datapath.v"
module datapath_tb;
	reg clk;
	reg reset;

	reg [15:0] keyboard [1:0];
	integer key;

datapath DATAPATH(.clk(clk), .reset(reset));

initial begin
	$dumpfile("dumpdatapath.vcd");
	$dumpvars(0, datapath_tb);

	clk = 1;
	DATAPATH.MIO.DSR = 16'h8000;
	repeat(4) begin
		toggle_clk;
	end
	reset = 1;
	toggle_clk;
	reset = 0;
	while (1) begin
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

always @(DATAPATH.MIO.DSR) begin
	$write("%c", DATAPATH.MIO.DDR);
	DATAPATH.MIO.DSR = 16'h8000;
end

always @(!DATAPATH.MIO.KBSR) begin
	getChar;
	DATAPATH.MIO.KBSR = 16'h8000;
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

task getChar;
	begin
		// while (keyboard[0] == 16'h0001) begin
		// 	$readmemh("keyboard.txt", keyboard, 0, 1);
		// end
		key = $fgetc('h8000_0000);
		DATAPATH.MIO.KBDR = key;
	end
endtask

endmodule