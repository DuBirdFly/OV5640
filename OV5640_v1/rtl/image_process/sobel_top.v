module sobel_top(
    // sys
    input  wire                         vga_clk                    ,
    // key
    input  wire        [  10:0]         iKey_value                 ,
    // input
    input  wire                         iVGA_de,iVGA_hs,iVGA_vs    ,
    input  wire        [  15:0]         iRGB_565                   ,//  RGB565格式
    // output
    output wire                         oVGA_hs,oVGA_vs,oVGA_de    ,
    output wire        [  15:0]         oVGA_565                    
);

wire                                    gray_de, gray_hsync, gray_vsync;
wire                   [   7:0]         gray_data                  ;
wire                                    sobel_hsync, sobel_vsync, sobel_de;
wire                   [  15:0]         sobel_data                 ;

assign oVGA_565 = sobel_data ? 16'h0000 : 16'hffff;
assign oVGA_hs = sobel_hsync;
assign oVGA_vs = sobel_vsync;
assign oVGA_de = sobel_de;

YCbCr u_YCbCr(
    // sys
    .clk                               (vga_clk                   ),
    // input
    .RGB_de                            (iVGA_de                   ),
    .RGB_hsync                         (iVGA_hs                   ),
    .RGB_vsync                         (iVGA_vs                   ),
    .RGB_data                          (iRGB_565                  ),
    // output
    .gray_de                           (gray_de                   ),
    .gray_hsync                        (gray_hsync                ),
    .gray_vsync                        (gray_vsync                ),
    .gray_data                         (gray_data[7:0]            ) 
);

sobel_filtering u_sobel_filtering(
    // sys
    .clk                               (vga_clk                   ),
    // param
    .key_value                         (iKey_value[10:0]          ),
    // input
    .Y_data                            (gray_data[7:0]            ),
    .Y_de                              (gray_de                   ),
    .Y_hsync                           (gray_hsync                ),
    .Y_vsync                           (gray_vsync                ),
    // output
    .sobel_hsync                       (sobel_hsync               ),
    .sobel_vsync                       (sobel_vsync               ),
    .sobel_de                          (sobel_de                  ),
    .sobel_data                        (sobel_data[15:0]          ) 
);


endmodule