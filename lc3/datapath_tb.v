module datapath_tb;
	reg clk;


datapath DATAPATH(.clk(clk));

initial begin
$dumpfile("dumpdatapath.vcd");
$dumpvars(0, datapath_tb);
$dumpvars(0, DATAPATH.REGFILE);

$monitor("IR: %b", DATAPATH.IR, " R1: %h", DATAPATH.REGFILE.regs[1]);

clk = 0;

while (DATAPATH.IR != 16'hFFFF) begin
	toggle_clk;
end

end

task toggle_clk;
    begin
        #10 clk = ~clk; // delay 10
        #10 clk = ~clk;
    end
endtask

endmodule