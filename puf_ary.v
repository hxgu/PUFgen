module puf_ary (/*AUTOARG*/
   // Outputs
   Q, Qn,
   // Inputs
   sel, clk, ce
   );

   output [5:0] Q;
   output [5:0] Qn;

   input [31:0] sel;
   input        clk;
   input        ce;

   (* RLOC = "X0Y0" *)
   puf puf0_ (// Outputs
              .Q                        (Q[0]),
              .Qn                       (Qn[0]),
              /*AUTOINST*/
              // Inputs
              .clk                      (clk),
              .ce                       (ce),
              .sel                      (sel[31:0]));

   (* RLOC = "X0Y1" *)
   puf puf1_ (// Outputs
              .Q                        (Q[1]),
              .Qn                       (Qn[1]),
              /*AUTOINST*/
              // Inputs
              .clk                      (clk),
              .ce                       (ce),
              .sel                      (sel[31:0]));

   (* RLOC = "X0Y2" *)
   puf puf2_ (// Outputs
              .Q                        (Q[2]),
              .Qn                       (Qn[2]),
              /*AUTOINST*/
              // Inputs
              .clk                      (clk),
              .ce                       (ce),
              .sel                      (sel[31:0]));

   (* RLOC = "X0Y3" *)
   puf puf3_ (// Outputs
              .Q                        (Q[3]),
              .Qn                       (Qn[3]),
              /*AUTOINST*/
              // Inputs
              .clk                      (clk),
              .ce                       (ce),
              .sel                      (sel[31:0]));

   (* RLOC = "X0Y4" *)
   puf puf4_ (// Outputs
              .Q                        (Q[4]),
              .Qn                       (Qn[4]),
              /*AUTOINST*/
              // Inputs
              .clk                      (clk),
              .ce                       (ce),
              .sel                      (sel[31:0]));

   (* RLOC = "X0Y5" *)
   puf puf5_ (// Outputs
              .Q                        (Q[5]),
              .Qn                       (Qn[5]),
              /*AUTOINST*/
              // Inputs
              .clk                      (clk),
              .ce                       (ce),
              .sel                      (sel[31:0]));

endmodule // puf_ary
