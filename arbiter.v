module arbiter (/*AUTOARG*/
   // Outputs
   Q, Qn,
   // Inputs
   clk, S, R
   );

   output Q;
   output Qn;

   input  clk;
   input  S;
   input  R;
   
`ifdef RTL_SIM
   reg    Q_pre;
   reg    Qn_pre;
   
   reg    Q;
   reg    Qn;
   
   always @ (S or R)
     case ({S,R})
       2'b00:
         begin
            Q_pre  <= 1'b1;
            Qn_pre <= 1'b1;
         end
       2'b01:
         begin
            Q_pre  <= 1'b0;
            Qn_pre <= 1'b1;
         end
       2'b10:
         begin
            Q_pre  <= 1'b1;
            Qn_pre <= 1'b0;
         end
     endcase // case ({S,R})

   always @ (posedge clk)
     begin
        Q  <= Q_pre;
        Qn <= Qn_pre;
     end
`else
   (* KEEP = "TRUE" *) wire   Q_pre, Qn_pre;

   (* RLOC = "X0Y0" *) (* BEL = "C6LUT" *) myNAND snand_ (.O(Q_pre), .I0(S), .I5(Qn_pre));
   (* RLOC = "X0Y0" *) (* BEL = "B6LUT" *) myNAND rnand_ (.O(Qn_pre), .I0(R), .I5(Q_pre));

   (* RLOC = "X0Y0" *) FD Q_  (.Q(Q),  .C(clk), .D(Q_pre));
   (* RLOC = "X0Y0" *) FD Qn_ (.Q(Qn), .C(clk), .D(Qn_pre));   
`endif
   
endmodule // arbiter

module myNAND (/*AUTOARG*/
   // Outputs
   O,
   // Inputs
   I0, I5
   );
   output O;
   input  I0;
   input  I5;

//   parameter delayI0 = 1;

//   reg    I0_d;
//   
//   always @ (I0)
//     I0_d <= #(delayI0) I0;

   (* RLOC = "X0Y0" *) (* LOCK_PINS = "all" *) LUT6 
             #(.INIT(64'h5555_5555_FFFF_FFFF)) nand_ (.O(O),
                                                      .I5(I5),
                                                      .I4(1'b1),
                                                      .I3(1'b1),
                                                      .I2(1'b1),
                                                      .I1(1'b1),
                                                      .I0(I0));
endmodule // myNAND
