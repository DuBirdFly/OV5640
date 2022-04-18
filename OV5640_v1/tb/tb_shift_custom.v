//~ `New testbench
`timescale  1ns / 1ps

module tb_shift_custom;

// Parameters
    parameter                           SYS_PERIOD = 20            ;// 系统时钟
    parameter                           VGA_PERIOD = 20            ;// VGA时钟
    parameter                           ROW  = 30                  ;
    parameter                           COL  = 30                  ;

// sys

// shift_custom Inputs
reg                                     vga_clk                = 0 ;
reg                                     rst_n                  = 0 ;
reg                    [   7:0]         din                    = 0 ;
reg                                     din_vld                = 0 ;

// shift_custom Outputs
wire                   [   7:0]         px3                        ;
wire                   [   7:0]         px5                        ;
wire                   [   7:0]         px1                        ;
wire                   [   7:0]         px2                        ;
wire                   [   7:0]         px4                        ;

// vga_clk
initial begin
    forever #(VGA_PERIOD/2)  vga_clk=~vga_clk;
end

initial begin
    #(VGA_PERIOD*2) rst_n  =  1;
end

shift_custom #(
    .ROW                               (ROW                       ),
    .COL                               (COL                       ) 
)  u_shift_custom (
    .vga_clk                           (vga_clk                   ),
    .rst_n                             (rst_n                     ),
    .din                               (din      [   7:0]         ),
    .din_vld                           (din_vld                   ),

    .px3                               (px3      [   7:0]         ),
    .px5                               (px5      [   7:0]         ),
    .px1                               (px1      [   7:0]         ),
    .px2                               (px2      [   7:0]         ),
    .px4                               (px4      [   7:0]         ) 
);

initial
begin

    $stop;
end

endmodule