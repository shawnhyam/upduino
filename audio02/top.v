
module oscillator(
  input clk, 
  input strobe, 
  input [15:0] frequency_step, 
  output [15:0] phase
);

  reg [15:0]	phase;
  always @(posedge clk)
    if (strobe)
	phase <= phase + frequency_step;
  
endmodule


module top (
	output wire gpio_28,
	output wire gpio_27,
	output wire gpio_26
);

	wire int_osc;
	wire vga_clk;

	// internal oscillator
	SB_HFOSC u_SB_HFOSC (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

	pll my_pll(.clock_in(int_osc), .clock_out(vga_clk));


	// music strobe pulse; runs at 1/512 the VGA clock (49.1 kHz)
	reg	[8:0] counter;
	always @(posedge vga_clk)
		counter <= counter + 1'b1;

	reg sound_strobe;
	always @(posedge vga_clk)
		sound_strobe <= (counter == 9'b111111111);

  reg [15:0] phase1;
  reg [15:0] phase2;

  assign gpio_26 = phase1[15];
  assign gpio_27 = phase2[15];
  assign gpio_28 = counter[8];

  oscillator osc1(vga_clk, sound_strobe, 16'd352, phase1);
  oscillator osc2(vga_clk, sound_strobe, 16'd443, phase2);


endmodule
