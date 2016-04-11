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
        35 : begin
            state <= 32;
        end
        32 : begin
            state <= IR[15:12];
        end
        1 : begin
            state <= 18;
        end
        5 : begin
            state <= 18;
        end
        9 : begin
            state <= 18;
        end
        15 : begin
            state <= 28;
        end
        28 : begin
            if (R) state <= 30;
            else state <= 28;
        end
        30 : begin
            state <= 18;
        end
        14 : begin
            state <= 18;
        end
        2, 6, 26 : begin
            state <= 25;
        end
        25 : begin
            if (R) state <= 27;
            else state <= 25;
        end
        27 : begin
            state <= 18;
        end
        10 : begin
            state <= 24;
        end
        24 : begin
            if (R) state <= 26;
            else state <= 24;
        end        
        11 : begin
            state <= 29;
        end
        29 : begin
            if (R) state <= 31;
            else state <= 29;
        end     
        31, 7, 3 : begin
            state <= 23;
        end
        23 : begin
            state <= 16;
        end
        16 : begin
            if (R) state <= 18;
            else state <= 16;
        end
        4 : begin
            if (IR[11]) state <= 21;
            else state <= 20;
        end
        21 : begin
            state <= 18;
        end        
        20 : begin
            state <= 18;
        end
        12 : begin
            state <= 18;
        end        
        0 : begin
            if (BEN) state <= 22;
            else state <= 18;
        end
        22 : begin
            state <= 18;
        end                

end

endmodule
