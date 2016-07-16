module control(clk, BEN, IR, R, PSR, INT, currentcs, reset);
    
    input clk;
    input reset;
    input BEN;
    input [15:0] IR;
    input R;
    input PSR; // PSR[15]
    input INT;

    reg [5:0] state;
    reg [39:0] controlsig [63:0];
    output wire [39:0] currentcs;


initial begin
	$readmemb("cs/controlstore", controlsig);
end

always @(posedge clk) begin
    if (reset) begin
        state <= 18;
    end
end

assign currentcs = controlsig[state];

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

        //Interrupt and Exception Control
        49 : begin
            if (PSR) state <= 45;
            else state <= 37;
        end
        45 : begin
            state <= 37;
        end
        37 : begin
            state <= 41;
        end
        41 : begin
            if (R) state <= 43;
            else state <= 41;
        end
        43 : begin
            state <= 47;
        end
        48 : begin
            if (R) state <= 50;
            else state <= 48;
        end
        50 : begin
            state <= 52;
        end
        52 : begin
            if (R) state <= 54;
            else state <= 52;
        end        
        54 : begin
            state <= 18;
        end
        
        13 : begin
        // MOVri
        // Should only take 1 cycle
            state <= 18;
        //    if (PSR) state <= 37;
        //    else state <= 45;
        end
        
        8 : begin
            if (PSR) state <= 44;
            else state <= 36;
        end
        44 : begin
            state <= 45;
        end
        36 : begin
            if (R) state <= 38;
            else state <= 36;
        end
        38 : begin
            state <= 39;
        end
        39 : begin
            state <= 40;
        end
        40 : begin
            if (R) state <= 42;
            else state <= 40;
        end
        42 : begin
            state <= 34;
        end
        34 : begin
            if (PSR) state <= 59;
            else state <= 51;
        end
        59 : begin
            state <= 18;
        end
        51 : begin
            state <= 18;
        end
        
    endcase

end

endmodule
