`default_nettype none               // mandatory for Verilog sanity
`timescale 1ns/1ps                  // mandatory to shut up Icarus Verilog

module block_ram #(
    parameter addr_width,
    parameter data_width,
    parameter hex = 1'b1,
    parameter filename
) (
    input logic [data_width-1:0] din, 
    input logic write_en, 
    input logic [addr_width-1:0] waddr, 
    input logic wclk, 
    input logic [addr_width-1:0] raddr, 
    input logic rclk, 
    output logic [data_width-1:0] dout
);
    logic [data_width-1:0] mem [(1<<addr_width)-1:0];

    initial begin
        $display("Loading palette.");
        if (hex)
          $readmemh(filename, mem);
        else
          $readmemb(filename, mem);
    end


  always @(posedge wclk) // Write memory.
  begin
    if (write_en)
      mem[waddr] <= din; // Using write address bus.
  end
  always @(posedge rclk) // Read memory.
  begin
    dout <= mem[raddr]; // Using read address bus.
  end
endmodule
