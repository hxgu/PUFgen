module puf_top (/*AUTOARG*/
   // Outputs
   valid_o, done_o, busy_o, Q_o, Qn_o,
   // Inputs
   req_i, sel_i, wait_cyc_i, clk50, srst_clk50, clk100, srst_clk100
   );

   // Outputs are sync'd to clk50
   output       valid_o;        // Q_o and Qn_o valid pulse
   output       done_o;         // Pulse asserted one clock before valid
   output       busy_o;         // asserted between req_i and valid_o
   output [5:0] Q_o;
   output [5:0] Qn_o;
   
   // Inputs are all sync'd to clk50
   input        req_i;          // single pulse asserted when busy is low
   input [31:0] sel_i;          // selection bits to the puf
   input [3:0]  wait_cyc_i;     // total period in 50MHz clock is (wait_cyc_i + 3)/2
                                // total period in 100MHz clock in wait_cyc_i + 3
   input        clk50;          // phase-locked to clk100
   input        srst_clk50;

   input        clk100;         // internal clock
   input        srst_clk100;
   
   // ===========================================================================
   // Internal timing states (100MHz clock domain)
   // ===========================================================================
   reg [4:0]    cntr_clk100;    // internal counter
   reg [5:0]    q_pre;
   reg [5:0]    qn_pre;
   reg          done_pre;
   wire         ce_clk100;
   wire         sample;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [5:0]           Q;                      // From puf_ary_ of puf_ary.v
   wire [5:0]           Qn;                     // From puf_ary_ of puf_ary.v
   // End of automatics
   
   assign       sample = (cntr_clk100[3:0] == wait_cyc_i[3:0]);

   // ===========================================================================
   // Frontend interface logic to the 100MHz clock domain
   // ===========================================================================
   reg          req_clk100_nedge;
   reg [31:0]   sel_clk100_nedge;
   
   always @ (negedge clk100)
     req_clk100_nedge <= req_i;

   always @ (negedge clk100)
     if (req_i)
       sel_clk100_nedge <= sel_i;
   
   assign ce_clk100 = cntr_clk100[4];
   
   always @ (posedge clk100)
     if (srst_clk100)
       cntr_clk100 <= 0;
     else if (~ce_clk100)
       begin
          if (req_clk100_nedge)
            cntr_clk100 <= {1'b1, 4'd0};
       end
     else if (sample)
       cntr_clk100 <= 0;
     else
       cntr_clk100 <= cntr_clk100 + 1;
   
   // ===========================================================================
   // PUF instantiations
   // ===========================================================================
   
   (* HU_SET = "puf_hset" *)
   puf_ary puf_ary_ (// Inputs
                     .sel               (sel_clk100_nedge[31:0]),
                     .clk               (clk100),
                     .ce                (ce_clk100),
                     /*AUTOINST*/
                     // Outputs
                     .Q                 (Q[5:0]),
                     .Qn                (Qn[5:0]));

   // ===========================================================================
   // Pure 100MHz clock domain
   // ===========================================================================
   always @ (posedge clk100)
     if (sample)
       begin
`ifdef RTL_SIM
          q_pre    <= sel_clk100_nedge[5:0];
          qn_pre   <= ~sel_clk100_nedge[5:0];
`else
          q_pre    <= Q;
          qn_pre   <= Qn;
`endif
       end

   always @ (posedge clk100)
     if (srst_clk100)
       done_pre <= 1'b0;
     else
       done_pre <= done_pre ? ~sample : (cntr_clk100[3:0] == (wait_cyc_i-2));

   // ===========================================================================
   // Back to 50MHz clock domain for output
   // ===========================================================================
   reg [5:0] Q_o;
   reg [5:0] Qn_o;
   reg       busy_o;
   reg       done_o;
   reg       valid_o;
   
   always @ (posedge clk50)
     if (srst_clk50)
       begin
          busy_o  <= 1'b0;
          done_o  <= 1'b0;
          valid_o <= 1'b0;
       end
     else
       begin
          busy_o  <= busy_o ? ~done_o : req_i;
          done_o  <= done_pre;
          valid_o <= done_o;
       end

   always @ (posedge clk50)
     if (srst_clk50)
       begin
          Q_o  <= 'h0;
          Qn_o <= 'h0;
       end
     else if (done_o)
       begin
          Q_o  <= q_pre;
          Qn_o <= qn_pre;
       end

endmodule // puf_top
