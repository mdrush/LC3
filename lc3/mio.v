`include "memory.v"

module mio(clk, MIO_EN, R_W, a, mio_out, d_in, R);

	input clk;
	input MIO_EN;
	input R_W;
	output wire R;
	reg R_io;
	wire R_mem;
	output wire [15:0] mio_out;
	input [15:0] d_in;
	input [15:0] a;
	wire [15:0] d_out;

	memory MEMORY(.clk(clk), .MEM_EN(MEM_EN), .R_W(R_W), .a(a),
	.d_out(d_out), .d_in(d_in), .R(R_mem));


	input [15:0] KBDR; //0
	reg [15:0] KBSR; //1
	reg [15:0] DDR;
	reg [15:0] DSR; //2
	reg [15:0] MCR;
	reg [15:0] INMUX;
	reg [1:0] INMUX_SEL;
	reg LD_KBSR;
	reg LD_DDR;
	reg LD_DSR;
	reg LD_MCR;
	reg MEM_EN;

initial begin
	DSR = 16'h8000;
	MCR = 16'h8000;
end

always @(*) begin
	LD_DDR = 0;
	LD_DSR = 0;
	LD_KBSR = 0;
	case (a)
		16'hFE00 : begin
			MEM_EN <= 0;
			if (MIO_EN) begin
				if (R_W)
					LD_KBSR <= 1;
				else
					INMUX_SEL <= 1;
			end
		end
		16'hFE02 : begin
			MEM_EN <= 0;
			if (MIO_EN && !R_W)
				INMUX_SEL <= 0;
		end
		16'hFE04 : begin
			MEM_EN <= 0;
			if (MIO_EN) begin
				if (R_W)
					LD_DSR <= 1;
				else
					INMUX_SEL <= 2;
			end
		end
		16'hFE06 : begin
			MEM_EN <= 0;
			if (MIO_EN && R_W)
				LD_DDR <= 1;
		end
		16'hFFFE : begin
			MEM_EN <= 0;
			if (MIO_EN && R_W)
				LD_MCR <= 1;
		end
		default : begin
			if (MIO_EN) begin
				MEM_EN <= 1;
				if (!R_W)
					INMUX_SEL <= 3;
			end
		end
	endcase

	case (INMUX_SEL)
		0 : INMUX <= KBDR;
		1 : INMUX <= KBSR;
		2 : INMUX <= DSR;
		3 : INMUX <= d_out;
	endcase

	
end

always @(posedge clk) begin
	if (LD_KBSR) begin
		KBSR <= d_in;
	end
		

	if (LD_DDR) begin
		DDR <= d_in;
	end
		

	if (LD_DSR) begin
		DSR <= d_in;
	end

	if (LD_MCR)
		MCR <= d_in;
		
end

assign R = (MEM_EN) ? R_mem : 1'b1;
assign mio_out = INMUX;
	

endmodule