// Project F Library - 640x480p60 Clock Generation (iCE40)
// (C)2021 Will Green, open source hardware released under the MIT License
// Learn more at https://projectf.io

`default_nettype none
`timescale 1ns / 1ps

// Set to 33.75 MHz (848x480 60 Hz) with 12 MHz XO
// iCE40 PLLs are documented in Lattice TN1251 and ICE Technology Library

module clock_gen_480p #(
    parameter FEEDBACK_PATH="SIMPLE",
    parameter DIVR=4'b0000,
    parameter DIVF=7'b0101100,
    parameter DIVQ=3'b100,
    parameter FILTER_RANGE=3'b001
) (
    input  logic clk,        // board oscillator
    input  logic rst,        // reset
    output logic clk_pix,    // pixel clock
    output logic clk_locked  // generated clock locked?
);

    logic locked;
    SB_PLL40_CORE #(
		.FEEDBACK_PATH(FEEDBACK_PATH),
		.DIVR(DIVR),	           	// DIVR =  0
		.DIVF(DIVF),	            // DIVF = 66
		.DIVQ(DIVQ),		        // DIVQ =  5
		.FILTER_RANGE(FILTER_RANGE)	// FILTER_RANGE = 1
	) uut (
		.LOCK(locked),
		.RESETB(rst),
		.BYPASS(1'b0),
		.REFERENCECLK(clk),
		.PLLOUTCORE(clk_pix)
	);

    // ensure clock lock is synced with pixel clock
    logic locked_sync_0;
    always_ff @(posedge clk_pix) begin
        locked_sync_0 <= locked;
        clk_locked <= locked_sync_0;
    end
endmodule