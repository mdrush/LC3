module memory(clk, MIO_EN, R_W, a, d_in, d_out, R, .global(global));

	input clk;
	reg [15:0] data_RAM [0:65535];
	input [15:0] d_in;
	output reg [15:0] d_out;
	input MIO_EN;
	input R_W;
	input [15:0] a;
	output reg R;
	input [15:0] global;

initial begin
	$readmemh("ram.obj", data_RAM);
end

always @(posedge clk) begin
	R = 0;
	if (MIO_EN) begin
		if (R_W) begin
			data_RAM[a] <= d_in;
			d_out <= d_in;
			R = 1;
		end
		else begin
			d_out <= data_RAM[a];
			R = 1;
		end
	end
end

endmodule