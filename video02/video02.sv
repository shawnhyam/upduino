module video02 (
    input  wire logic clk_12m,     // 12 MHz clock
    input  wire logic btn_rst,      // reset button (active low)
    output      logic vga_hsync,    // horizontal sync
    output      logic vga_vsync,    // vertical sync
    output      logic [3:0] vga_r,  // 4-bit VGA red
    output      logic [3:0] vga_g,  // 4-bit VGA green
    output      logic [3:0] vga_b   // 4-bit VGA blue
    );

    // generate pixel clock
    logic clk_pix;
    logic clk_locked;
    clock_gen_480p clock_pix_inst (
       .clk(clk_12m),
       .rst(1'b1),  // reset button is active low
       .clk_pix,
       .clk_locked
    );

    // display timings
    //localparam CORDW = 10;  // screen coordinate width in bits
    logic [10:0] sx;
    logic [9:0] sy;
    logic hsync, vsync, de;
    simple_display_timings_480p display_timings_inst (
        .clk_pix,
        .rst(!clk_locked),  // wait for clock lock
        .sx,
        .sy,
        .hsync,
        .vsync,
        .de
    );

    // 32 x 32 pixel square
    logic q_draw;
    always_comb q_draw = (sx < 32 && sy < 32) ? 1 : 0;

    // VGA output
    always_ff @(posedge clk_pix) begin
        vga_hsync <= hsync;
        vga_vsync <= vsync;
        vga_r <= !de ? 4'h0 : (q_draw ? 4'hF : 4'h0);
        vga_g <= !de ? 4'h0 : (q_draw ? 4'h8 : 4'h8);
        vga_b <= !de ? 4'h0 : (q_draw ? 4'h0 : 4'hF);
    end
endmodule