module alu(A, B, ALUK, OUT);
	input [15:0] A;
	input [15:0] B;
	input [1:0] ALUK; // ADD, AND, NOT, PASSA
	output reg [15:0] OUT;

always @(*) begin
	case (ALUK)
		0 : OUT = A + B; //ADD
		1 : OUT = A & B; //AND
		2 : OUT = ~A; //NOT
		3 : OUT = A; //PASSA
	endcase
end

endmodule