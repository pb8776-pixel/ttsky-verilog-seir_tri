`default_nettype none
`timescale 1ns / 1ps

/* This testbench instantiates the module and provides wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end

  // Testbench signals:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate DUT
  tt_um_sierpinski_lfsr user_project (
`ifdef GL_TEST
      .VPWR   (VPWR),
      .VGND   (VGND),
`endif
      .clk    (clk),     // system clock
      .rst_n  (rst_n),   // active-low reset
      .ena    (ena),     // enable
      .ui_in  (ui_in),   // not used
      .uo_out (uo_out),  // LFSR output
      .uio_in (uio_in),  // not used
      .uio_out(uio_out), // not used
      .uio_oe (uio_oe)   // not used
  );

  // Generate clock
  initial clk = 0;
  always #5 clk = ~clk;  // 100MHz clock (period = 10ns)

  // Stimulus
  initial begin
    // Initialize
    rst_n  = 0;
    ena    = 0;
    ui_in  = 8'b0;
    uio_in = 8'b0;

    // Apply reset
    #20;
    rst_n = 1;
    ena   = 1;   // enable LFSR

    // Run for a while
    #200;
    $finish;
  end

endmodule
