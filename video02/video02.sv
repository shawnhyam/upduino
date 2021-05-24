/*



*/


typedef logic [3:0] color_channel_t;

typedef struct packed {
    color_channel_t red;
    color_channel_t green;
    color_channel_t blue;
} color_channels_t;

typedef union packed {
    color_channels_t channels;
    logic [11:0] data;
} color_t;

module video02 (
    input  logic clk_12m,     // 12 MHz clock
    input  logic btn_rst,      // reset button (active low)
    output logic vga_hsync,    // horizontal sync
    output logic vga_vsync,    // vertical sync
    output color_channel_t vga_r,  // 4-bit VGA red
    output color_channel_t vga_g,  // 4-bit VGA green
    output color_channel_t vga_b   // 4-bit VGA blue
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

    // palette memory
    block_ram #(
        .addr_width(8),
        .data_width(16),
        .filename("palette.mem")
    ) palette_mem (
        .din(16'h0000),
        .write_en(1'b0),
        .waddr(8'h00),
        .wclk(clk_pix),
        .raddr(palette_idx),
        .rclk(clk_pix),
        .dout(color)
    );

    logic [7:0] palette_idx;
    logic [15:0] color;

    logic [7:0] tile;
    logic [11:0] tile_addr;

    always_comb
        tile_addr = { sy[8:4], sx[9:3] };

    // TODO need to run this only once per tile
    // tile memory
    block_ram #(
        .addr_width(12),
        .data_width(8),
        .hex(1'b1),
        .filename("vram.mem")
    ) vram_mem (
        .din(8'h00),
        .write_en(1'b0),
        .waddr(12'h000),
        .wclk(clk_pix),
        .raddr(tile_addr),
        .rclk(clk_pix),
        .dout(tile)
    );

    logic [15:0] pattern;
    logic [10:0] pattern_addr;

    logic [3:0] y_offset;
    logic [2:0] x_offset;

   // font memory
    block_ram #(
        .addr_width(11),
        .data_width(16),
        .hex(1'b0),
        .filename("font_vga_8x16w.mem")
    ) font_mem (
        .din(16'h0000),
        .write_en(1'b0),
        .waddr(8'h00),
        .wclk(clk_pix),
        .raddr(pattern_addr),
        .rclk(clk_pix),
        .dout(pattern)
    );

    // 32 x 32 pixel square
    logic q_draw;
    always_comb q_draw = (sx < 32 && sy < 32) ? 1 : 0;

    always_comb
        palette_idx = { sy[8:5], sx[8:5] };

    logic [3:0] pattern_bit;
    logic [3:0] next_pattern_bit;
    logic fg;

    always_comb begin
        next_pattern_bit = { ~y_offset[0], ~x_offset[2:0] };
        pattern_addr = { tile, y_offset[3:1] };
        //pattern_addr = { 1'b0, sx[9:3], sy[3:1] };
        fg = pattern[pattern_bit];
    end

    // VGA output
    always_ff @(posedge clk_pix) begin
        y_offset <= sy[3:0];
        x_offset <= sx[2:0];
        pattern_bit <= next_pattern_bit;
        vga_hsync <= hsync;
        vga_vsync <= vsync;
        //vga_r <= !de ? 4'h0 : (q_draw ? 4'hF : 4'h0);
        vga_r <= !de ? 4'h0 : (fg ? color[14:11] : 4'h0);
        vga_g <= !de ? 4'h0 : (fg ? color[9:6]: 4'h0);
        vga_b <= !de ? 4'h0 : (fg ? color[4:1]: 4'h0);
    end
endmodule