//`include "../includes/definitions.v"

module shuffle4 (/*AUTOARG*/
   // Outputs
   dout,
   // Inputs
   din, sel
   );

   output [1:0] dout;
   input [1:0]  din;
   input [3:0]  sel;

   wire [1:0]   shf_d0;
   wire [1:0]   shf_d1;
   wire [1:0]   shf_d2;
   wire [1:0]   shf_d3;

   // Each shuffle unit is equivalent to:
   // assign O5 = sel ? I1 : I0;
   // assign O6 = sel ? I0 : I1;
   
   (* RLOC = "X0Y0" *) (* BEL = "D6LUT" *) (* LOCK_PINS = "all" *)
   LUT6_2 #(.INIT(64'hAAAACCCC_CCCCAAAA))
   shf0_ (.O6(shf_d0[1]), .O5(shf_d0[0]),
          .I5(1'b1),      .I4(sel[0]),
          .I3(1'b1),      .I2(1'b1),
          .I1(din[1]),    .I0(din[0]));
   
   (* RLOC = "X0Y0" *) (* BEL = "C6LUT" *) (* LOCK_PINS = "all" *)
   LUT6_2 #(.INIT(64'hAAAACCCC_CCCCAAAA))
   shf1_ (.O6(shf_d1[1]), .O5(shf_d1[0]),
          .I5(1'b1),      .I4(sel[1]),
          .I3(1'b1),      .I2(1'b1),
          .I1(shf_d0[1]), .I0(shf_d0[0]));

   (* RLOC = "X0Y0" *) (* BEL = "B6LUT" *) (* LOCK_PINS = "all" *)
   LUT6_2 #(.INIT(64'hAAAACCCC_CCCCAAAA))
   shf2_ (.O6(shf_d2[1]), .O5(shf_d2[0]),
          .I5(1'b1),      .I4(sel[2]),
          .I3(1'b1),      .I2(1'b1),
          .I1(shf_d1[1]), .I0(shf_d1[0]));

   (* RLOC = "X0Y0" *) (* BEL = "A6LUT" *) (* LOCK_PINS = "all" *)
   LUT6_2 #(.INIT(64'hAAAACCCC_CCCCAAAA))
   shf3_ (.O6(shf_d3[1]), .O5(shf_d3[0]),
          .I5(1'b1),      .I4(sel[3]),
          .I3(1'b1),      .I2(1'b1),
          .I1(shf_d2[1]), .I0(shf_d2[0]));

   assign dout = shf_d3;
   
endmodule // shuffle4
