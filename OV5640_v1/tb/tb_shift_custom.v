//~ `New testbench
`timescale  1ns / 1ps

module tb_shift_custom;

// Parameters
    parameter                           SYS_PERIOD = 20            ;// 系统时钟
    parameter                           VGA_PERIOD = 20            ;// VGA时钟

// sobel_img_gen Outputs
reg                                     VGA_HS                     ;
reg                                     VGA_VS                     ;
reg                                     VGA_DE                     ;
reg                    [  11:0]         VGA_X                      ;
reg                    [  11:0]         VGA_Y                      ;
wire                                    o_sobel_data               ;

// shift_custom Inputs
reg                                     vga_clk                = 0 ;
reg                                     rst_n                  = 0 ;
reg                    [   7:0]         din                    = 0 ;
reg                                     din_vld                = 0 ;

// shift_custom Outputs
wire                   [   7:0]         px1,xp2,px3,px4,px5        ;

// vga_clk
initial begin
    forever #(VGA_PERIOD/2)  vga_clk=~vga_clk;
end

// rst_n
initial begin
    #(SYS_PERIOD*2) rst_n  =  1;
end

// inst sobel_img_gen
sobel_img_gen u_sobel_img_gen(
    // sys
    .rst_n                             (rst_n                     ),
    .vga_clk                           (vga_clk                   ),
    // output
    .VGA_HS                            (VGA_HS                    ),
    .VGA_VS                            (VGA_VS                    ),
    .VGA_DE                            (VGA_DE                    ),
    .VGA_X                             (VGA_X[11:0]               ),
    .VGA_Y                             (VGA_Y[11:0]               ),
    .o_sobel_data                      (o_sobel_data              ) 
);

// inst shift_custom
shift_custom #(
    .ROW                               (30                        ),
    .COL                               (30                        ) 
)  u_shift_custom (
    // sys
    .vga_clk                           (vga_clk                   ),
    .rst_n                             (rst_n                     ),
    // input
    .din                               (o_sobel_data              ),
    .din_vld                           (VGA_DE                    ),
    // output
    .px1                               (px1      [   7:0]         ),
    .px2                               (px2      [   7:0]         ),
    .px3                               (px3      [   7:0]         ),
    .px4                               (px4      [   7:0]         ),
    .px5                               (px5      [   7:0]         ) 
);

// end time
initial begin
    #((VGA_PERIOD*30*30)*3);
    $stop;
end

endmodule