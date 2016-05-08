module microsequencer(INT, R, IR, BEN, PSR, cond, next_state, J, IRD);

  input INT; //triggers interrupt from io, only tested in state 18
  input R; //end of mem operation
  input [15:11] IR; //addressing mode (user subroutine)
  input BEN; //branch
  input PSR; //supervisor or user mode

  input IRD;
  input  [2:0] cond;
  output reg [5:0] next_state; //address of next state
  input [5:0] J;
  
  always @(cond) begin
    case (cond)
      3'b011 : next_state = (IR[11]) ? 6'b000001 : 6'b000000; //Address Mode
      3'b001 : next_state = (R) ? 6'b000010 : 6'b000000; //Memory Ready
      3'b010 : next_state = (BEN) ? 6'b000100 : 6'b000000; //Branch
      3'b100 : next_state = (PSR) ? 6'b001000 : 6'b000000; //Privilege Mode
      3'b101 : next_state = (INT) ? 6'b010000 : 6'b000000; //Interrupt Present
      default: next_state = 6'b000000;
    endcase
    next_state <= next_state | J;
    if (IRD) next_state <= {2'b00, IR[15:12]};

  end


endmodule
