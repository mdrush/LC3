module microsequencer(INT, R, IR, BEN, PSR, cond, controlst, J, IRD);

  input INT; //triggers interrupt from io, only tested in state 18
  input R; //end of mem operation
  input [15:11] IR; //addressing mode (user subroutine)
  input BEN; //branch
  input PSR; //supervisor or user mode

  input IRD;
  input  [2:0] cond;
  output reg [5:0] controlst; //address of next state
  input [5:0] J;
  
  always @(cond) begin
    case (cond)
      3'b011 : controlst = (INT) ? 6'b000001 : 6'b000000; //Address Mode
      3'b001 : controlst = (R) ? 6'b000010 : 6'b000000; //Memory Ready
      3'b010 : controlst = (IR[11]) ? 6'b000100 : 6'b000000; //Branch
      3'b100 : controlst = (BEN) ? 6'b001000 : 6'b000000; //Privilege Mode
      3'b101 : controlst = (PSR) ? 6'b010000 : 6'b000000; //Interrupt Present
      default: controlst = 6'b000000;
    endcase
    controlst <= controlst | J;
    if (IRD) controlst <= {2'b00, IR[15:12]};

  end


endmodule