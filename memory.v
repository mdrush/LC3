module memory(clk, MEM_EN, R_W, a, d_in, d_out, R);

	input clk;
	reg [15:0] data_RAM [0:65535];
	input [15:0] d_in;
	output reg [15:0] d_out;
	input MEM_EN;
	input R_W;
	input [15:0] a;
	output reg R;

initial begin
	$readmemh("asm/lc3os/lc3os.obj", data_RAM);
	//$readmemh("ram.obj", data_RAM);
	$readmemh("asm/32bit.obj", data_RAM);
end

always @(posedge clk) begin
	R = 0;
	if (MEM_EN) begin
		if (R_W) begin
			data_RAM[a] <= d_in;
			d_out <= d_in;
			R <= 1;
		end
		else begin
			d_out <= data_RAM[a];
			R <= 1;
		end
	end
end

endmodule