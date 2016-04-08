module control(clk, IR, R, N, Z, P);
    
    input clk;
    input IR;
    input R;

    input N;
    input Z;
    input P;
    wire BEN; //p131-132

    wire SR1;
    wire [1:0] SR1MUX; //11.9 -> src IR[11:9], 8.6 -> src 8.6, SP -> src R6
    wire [2:0] DR;
    wire [1:0] DRMUX; //11.9 -> dest IR[11:9], R7 -> dest R7, SP -> dest R6
  
    //parameter  IDLE=0, RUN=1, DONE=2 ;
    reg [5:0] state;

microsequencer MICROSEQUENCER(.INT(INT),
    .R(R),
    .IR(IR),
    .BEN(BEN),
    .PSR(PSR),
    .cond(cond),
    .controlst(controlst),
    .J(J),
    .IRD(IRD));

always @(posedge clk) begin
    case (DRMUX)
        1 : assign DR = IR[11:9];
        2 : assign DR = 3'b110; //R6
        3 : assign DR = 3'b111; //R7
    endcase

    case (SR1MUX)
        1 : assign SR1 = IR[11:9];
        2 : assign SR1 = IR[8:6];
        3 : assign SR1 = 3'b110; //R6
    endcase

    assign BEN = ((IR[11] & N) | (IR[10] & Z) | (IR[9] & P));
end

always @(posedge clk) begin
    case (state)
        18 : begin //prep for fetch
            if (INT) state <= 49;
            else state <= 33;
        end
        33 : begin //wait for memory
            if (R) state <= 35;
            else state <= 33;
        end
        




end

endmodule