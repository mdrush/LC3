// Testbench
module test;

  reg  clk;
  reg [3:0] in;
  wire [6:0] out;
  
  // Instantiate device under test
  sevenseg SEVENSEG(.in(in),
          .out(out));
  
  initial begin
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(1, test);

    clk = 0;
    // Display 0-9 and default
    for (in = 0; in <= 10; in = in + 1) begin
    toggle_clk;
    $display(" %1b\n%1b %1b\n %1b\n%1b %1b\n %1b\n",
             out[6], out[1], out[5], out[0], out[2], out[4], out[3]);
      // $display("%7b", out);
    end

  end
  
  task toggle_clk;
    begin
      #10 clk = ~clk;
      #10 clk = ~clk;
    end
  endtask
  
endmodule