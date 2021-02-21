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

//----------------------------------------------------------------------------
//                                                                          --
//                         Module Declaration                               --
//                                                                          --
//----------------------------------------------------------------------------
module rgb_blink (
  // outputs
  output wire led_red  , // Red
  output wire led_blue , // Blue
  output wire led_green,  // Green
  output wire gpio_28
);

  wire        int_osc            ;
  reg  [27:0] frequency_counter_i;

//----------------------------------------------------------------------------
//                                                                          --
//                       Internal Oscillator                                --
//                                                                          --
//----------------------------------------------------------------------------
  SB_HFOSC u_SB_HFOSC (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));


  music music(int_osc, gpio_28);


//----------------------------------------------------------------------------
//                                                                          --
//                       Counter                                            --
//                                                                          --
//----------------------------------------------------------------------------
  always @(posedge int_osc) begin
    frequency_counter_i <= frequency_counter_i + 1'b1;
  end





//----------------------------------------------------------------------------
//                                                                          --
//                       Instantiate RGB primitive                          --
//                                                                          --
//----------------------------------------------------------------------------
  SB_RGBA_DRV RGB_DRIVER (
    .RGBLEDEN(1'b1                                            ),
    .RGB0PWM (frequency_counter_i[25]&frequency_counter_i[24] ),
    .RGB1PWM (frequency_counter_i[25]&~frequency_counter_i[24]),
    .RGB2PWM (~frequency_counter_i[25]&frequency_counter_i[24]),
    .CURREN  (1'b1                                            ),
    .RGB0    (led_green                                       ), //Actual Hardware connection
    .RGB1    (led_blue                                        ),
    .RGB2    (led_red                                         )
  );
  defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
  defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

endmodule
