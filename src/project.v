/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_sierpinski_lfsr (
    input  wire clk,         // system clock
    input  wire rst_n,       // active-low reset
    input  wire ena,         // enable signal from Tiny Tapeout
    input  wire [7:0] ui_in, // unused in this design
    output wire [7:0] uo_out,// map LFSR output here
    input  wire [7:0] uio_in,// unused
    output wire [7:0] uio_out, // unused
    output wire [7:0] uio_oe   // unused
);

    reg [7:0] lfsr;

    // Feedback taps for maximal-length LFSR (x^8 + x^6 + x^5 + x^4 + 1)
    wire feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            lfsr <= 8'b0000_0001;  // seed value
        else if (ena)              // only update when enabled
            lfsr <= {lfsr[6:0], feedback};
    end

    // Drive outputs
    assign uo_out  = lfsr;        // Send triangle row pattern out
    assign uio_out = 8'b0;        // not used
    assign uio_oe  = 8'b0;        // not used

endmodule
