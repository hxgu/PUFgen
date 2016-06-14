//`include "../includes/definitions.v"

module puf (/*AUTOARG*/
   // Outputs
   Q, Qn,
   // Inputs
   clk, ce, sel
   );

   output Q;
   output Qn;

   input  clk;
   input  ce;

   input [31:0] sel;

   wire        S, R;
   wire [1:0]  din;
   wire [1:0]  dout;

   assign din = {S,R};
   
   (* RLOC = "X0Y0" *) FD A_ (.Q(S), .C(clk), .D(ce));   
   (* RLOC = "X0Y0" *) FD B_ (.Q(R), .C(clk), .D(ce));

   (* RLOC = "X0Y0" *) shuffle32 shf_ (/*AUTOINST*/
                                       // Outputs
                                       .dout            (dout[1:0]),
                                       // Inputs
                                       .din             (din[1:0]),
                                       .sel             (sel[31:0]));
   
   (* RLOC = "X8Y0" *) arbiter arb_  (.clk(clk),
                                      .S(dout[1]),
                                      .R(dout[0]),
                                      .Q(Q),
                                      .Qn(Qn));
   
endmodule // puf
