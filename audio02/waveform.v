module music(
    input clk,
    output speaker
);

reg [23:0] tone;
always @(posedge clk) tone <= tone+1;

wire [6:0] ramp = (tone[23] ? tone[22:16] : ~tone[22:16]);
wire [14:0] clkdivider = {2'b01, ramp, 6'b000000};

reg [18:0] counter;
always @(posedge clk) if(counter==0) counter <= clkdivider; else counter <= counter-1;

reg speaker;
always @(posedge clk) if(counter==0) speaker <= ~speaker;

endmodule

module top (
  output wire gpio_28
);

  wire        int_osc            ;
  reg  [27:0] frequency_counter_i;

  // internal oscillator
  SB_HFOSC u_SB_HFOSC (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

  music music(int_osc, gpio_28);

  always @(posedge int_osc) begin
    frequency_counter_i <= frequency_counter_i + 1'b1;
  end

endmodule
