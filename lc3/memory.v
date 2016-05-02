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
	// data_RAM[16'h3000] = 16'h1265; // ADD R1, R1, #5
	// data_RAM[16'h3001] = 16'h1021; // ADD R0, R0, #1
	// data_RAM[16'h3002] = 16'h127f; // ADD R1, R1, #15
	// data_RAM[16'h3003] = 16'h03fd; // BRp 111111101
	// data_RAM[16'h3004] = 16'hf025;

	//st 3000 1265 3202 2001 f025 0000 
		// data_RAM[16'h3000] = 16'h1265;
		// data_RAM[16'h3001] = 16'h3202;
		// data_RAM[16'h3002] = 16'h2001;
		// data_RAM[16'h3003] = 16'hf025;
		// data_RAM[16'h3004] = 16'h0000;

	//multiply
	//3000 5020 2208 2408 1001 14bf 03fd 3005
	//1000 2203 f025 0008 0007 0000 
	// data_RAM[16'h3000] = 16'h5020;
	// data_RAM[16'h3001] = 16'h2208;
	// data_RAM[16'h3002] = 16'h2408;
	// data_RAM[16'h3003] = 16'h1001;
	// data_RAM[16'h3004] = 16'h14bf;
	// data_RAM[16'h3005] = 16'h03fd;
	// data_RAM[16'h3006] = 16'h3005;
	// data_RAM[16'h3007] = 16'h1000;
	// data_RAM[16'h3008] = 16'h2203;
	// data_RAM[16'h3009] = 16'hf025;
	// data_RAM[16'h300a] = 16'h0008;
	// data_RAM[16'h300b] = 16'h0007;
	// data_RAM[16'h300c] = 16'h0000;

	//sub - working
	//3000 2203 4803 1060 f025 cccc 3e04 927f 1261 2e01 c1c0 0000 
	// data_RAM[16'h3000] = 16'h2203;
	// data_RAM[16'h3001] = 16'h4803;
	// data_RAM[16'h3002] = 16'h1060;
	// data_RAM[16'h3003] = 16'hf025;
	// data_RAM[16'h3004] = 16'hcccc;
	// data_RAM[16'h3005] = 16'h3e04;
	// data_RAM[16'h3006] = 16'h927f;
	// data_RAM[16'h3007] = 16'h1261;
	// data_RAM[16'h3008] = 16'h2e01;
	// data_RAM[16'h3009] = 16'hc1c0;
	// data_RAM[16'h300a] = 16'h0000;
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