`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:56:31 06/13/2016 
// Design Name: 
// Module Name:    Top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Top (/*AUTOARG*/
   // Outputs
   RsTx, 
	// Inputs
   RsRx, clk
   );

`include "seq_definitions.v"

// USB-UART
   input        RsRx;
   output       RsTx;

// Logic
   input        clk;                  // 100MHz

/*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [seq_dp_width-1:0] seq_tx_data;         // From puf_ of seq.v
   wire                 seq_tx_valid;           // From puf_ of seq.v
   wire [7:0]           uart_rx_data;           // From uart_top_ of uart_top.v
   wire                 uart_rx_valid;          // From uart_top_ of uart_top.v
   wire                 uart_tx_busy;           // From uart_top_ of uart_top.v
   wire [5:0]           Q_o;
	wire [5:0]           Qn_o;
	
	
	wire                 valid_o;
	wire                 done_o;
	wire                 busy_o;
	wire                 rst;
   wire                 clk50;
   
	reg [seq_dp_width-1:0] puf_sel;             // From puf_ to puf_
   
   always @ (posedge clk) 
       clk50 <= !clk50; 

   puf_top puf_top_ (// Outputs
                     .valid_o           (valid_o), 
							.done_o            (done_o), 
							.busy_o            (busy_o),  
							.Q_o               (Q_o), 
							.Qn_o              (Qn_o),
                     // Inputs
                     .req_i             (),           
							.sel_i             (puf_sel), 
							.wait_cyc_i        (), 
							.clk50             (clk50), 
							.srst_clk50        (), 
							.clk100            (clk), 
							.srst_clk100       ());

   uart_top uart_top_ (// Outputs
                       .o_tx            (RsTx),
                       .o_tx_busy       (uart_tx_busy),
                       .o_rx_data       (uart_rx_data[7:0]),
                       .o_rx_valid      (uart_rx_valid),
                       // Inputs
                       .i_rx            (RsRx),
                       .i_tx_data       (seq_tx_data[seq_dp_width-1:0]),
                       .i_tx_stb        (seq_tx_valid),
                       /*AUTOINST*/
                       // Inputs
                       .clk             (clk),
                       .rst             (rst));
endmodule
