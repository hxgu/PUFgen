module shuffle32(/*AUTOARG*/
   // Outputs
   dout,
   // Inputs
   din, sel
   );

   output [1:0] dout;
   input [1:0]  din;
   input [31:0] sel;

   wire [1:0]   stg0;
   wire [1:0]   stg1;
   wire [1:0]   stg2;
   wire [1:0]   stg3;
   wire [1:0]   stg4;
   wire [1:0]   stg5;
   wire [1:0]   stg6;
   wire [1:0]   stg7;
   
   (* RLOC = "X0Y0" *) shuffle4 shf0_ (.dout(stg0),
                                       .din(din),
                                       .sel(sel[31:28]));
   
   (* RLOC = "X1Y0" *) shuffle4 shf1_ (.dout(stg1),
                                       .din(stg0),
                                       .sel(sel[27:24]));

   (* RLOC = "X2Y0" *) shuffle4 shf2_ (.dout(stg2),
                                       .din(stg1),
                                       .sel(sel[23:20]));

   (* RLOC = "X3Y0" *) shuffle4 shf3_ (.dout(stg3),
                                       .din(stg2),
                                       .sel(sel[19:16]));

   (* RLOC = "X4Y0" *) shuffle4 shf4_ (.dout(stg4),
                                       .din(stg3),
                                       .sel(sel[15:12]));

   (* RLOC = "X5Y0" *) shuffle4 shf5_ (.dout(stg5),
                                       .din(stg4),
                                       .sel(sel[11:08]));

   (* RLOC = "X6Y0" *) shuffle4 shf6_ (.dout(stg6),
                                       .din(stg5),
                                       .sel(sel[07:04]));

   (* RLOC = "X7Y0" *) shuffle4 shf7_ (.dout(stg7),
                                       .din(stg6),
                                       .sel(sel[03:00]));

   assign dout = stg7;
   
endmodule // shuffle32
