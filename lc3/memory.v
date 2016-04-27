module memory(clk, MIO_EN, R_W, a, d_in, d_out, R);

	input clk;
	reg [15:0] data_RAM [0:65535];
	input [15:0] d_in;
	output reg [15:0] d_out;
	input MIO_EN;
	input R_W;
	input [15:0] a;
	output reg R;

initial begin
	data_RAM[16'h3000] = 16'h1265;
	data_RAM[16'h3001] = 16'h1021;
	data_RAM[16'h3002] = 16'h127f;
	data_RAM[16'h3003] = 16'h03fd;
	data_RAM[16'h3004] = 16'hf025;
end

always @(posedge clk) begin
	R = 0;
	if (MIO_EN) begin
		if (R_W) begin
			data_RAM[a] <= d_in;
			d_out <= d_in;
		end
		else begin
			d_out <= data_RAM[a];
			R = 1;
		end
	end
end

endmodule