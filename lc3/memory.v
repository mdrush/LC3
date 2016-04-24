module memory(clk, MIO_EN, R_W, a, d_in, d_out, global);

	input clk;
	reg [15:0] data_RAM [0:65536];
	input [15:0] d_in;
	output reg [15:0] d_out;
	input MIO_EN;
	input R_W;
	input [15:0] a;
	input [15:0] global;

initial begin
	data_RAM[0] = 16'h5260;
	data_RAM[1] = 16'h1265;
	data_RAM[2] = 16'h03fe;
	data_RAM[3] = 16'h1265;
	data_RAM[5] = 16'hf025;
end

always @(posedge clk) begin
	if (MIO_EN) begin
		if (R_W) begin
			data_RAM[a] <= d_in;
			d_out <= d_in;
		end
		else begin
			d_out <= data_RAM[a];
		end
	end
end

endmodule