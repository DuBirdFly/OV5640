//~ `New testbench

`timescale  1ns / 1ps

module sobel_img_gen(
    // sys
    input                               rst_n                      ,
    input                               sys_clk                    ,
    input                               vga_clk                    ,

    // output
    output reg                          VGA_HS                     ,// oVGA_H_SYNC 打1拍
    output reg                          VGA_VS                     ,// oVGA_V_SYNC 打1拍
    output reg                          VGA_DE                     ,// oVGA_DE 打1拍
    output reg         [  11:0]         VGA_X                      ,// Coord_X 打1拍
    output reg         [  11:0]         VGA_Y                      ,// Coord_Y 打1拍
    output wire                         o_sobel_data                // 1位的sobel数据
);

    parameter                           SYS_PERIOD = 20            ;// 系统时钟
    parameter                           VGA_PERIOD = 20            ;// VGA时钟
    parameter                           ROW        = 30            ;
    parameter                           COL        = 30            ;

// reg                    [   0:0]         data_men   [ROW*COL - 1:0];//30*30-1 = 899  备份
reg                    [   0:0]         data_men   [ROW*COL - 1:0];//30*30-1 = 899  备份

// color_bar Inputs
reg                    [   9:0]         iRed                   = 0 ;

// color_bar Inputs
wire                   [  11:0]         Coord_X                    ;
wire                   [  11:0]         Coord_Y                    ;
// color_bar Outputs
wire                   [   4:0]         oVGA_R                     ;
wire                                    oVGA_H_SYNC                ;
wire                                    oVGA_V_SYNC                ;
wire                                    oVGA_DE                    ;

// data_men
reg                                     data_men_now               ;

// assign
assign o_sobel_data = (oVGA_R[0] == 1'b1) ? 1'b1 : 1'b0;            // 只要color_bar的oVGA_R有一位输出为1, 那么就为1

// init men
initial begin
    $readmemh("D:/PrjWorkspace/OV5640/Prj/matlab/OV5640/img/img.txt", data_men);
end

// data_men_now
always @(*) begin
    if (Coord_X < COL && Coord_Y < ROW)
        data_men_now = data_men[Coord_X+Coord_Y*COL];
    else
        data_men_now = data_men[ROW*COL-1];
end

// sobel_data
always @(*) begin
    if (oVGA_DE & data_men_now == 1'b1)
        iRed = 10'b11_1111_1111;
    else
        iRed = 10'b00_0000_0000;
end

// end time
initial begin
    #(VGA_PERIOD*ROW*COL*3);
    $stop;
end

// inst color_bar
color_bar u_color_bar (
    // sys
    .iCLK                              (vga_clk                   ),
    .rst                               (~rst_n                    ),
    // input
    .iRed                              (iRed         [   9:0]     ),
    .iGreen                            (                          ),
    .iBlue                             (                          ),
    // output
    .oCoord_X                          (Coord_X                   ),
    .oCoord_Y                          (Coord_Y                   ),
    .oVGA_R                            (oVGA_R       [   4:0]     ),
    .oVGA_G                            (                          ),
    .oVGA_B                            (                          ),
    .oVGA_H_SYNC                       (oVGA_H_SYNC               ),
    .oVGA_V_SYNC                       (oVGA_V_SYNC               ),
    .oVGA_SYNC                         (                          ),// useless, always 0
    .oVGA_BLANK                        (                          ),// = oVGA_H_SYNC & oVGA_V_SYNC;
    .oVGA_CLOCK                        (                          ),// uesless, assign oVGA_CLOCK =	iCLK;
    .oVGA_DE                           (oVGA_DE                   ) // = h_active & v_active
);

// 集中处理打1拍
always @(posedge vga_clk or negedge rst_n) begin
    if (!rst_n) begin
        VGA_HS <= 1'b0;
        VGA_VS <= 1'b0;
        VGA_DE <= 1'b0;
        VGA_X  <= 1'b0;
        VGA_Y  <= 1'b0;
    end
    else begin
        VGA_HS <= oVGA_H_SYNC;
        VGA_VS <= oVGA_V_SYNC;
        VGA_DE <= oVGA_DE;
        VGA_X  <= Coord_X[11:0];
        VGA_Y  <= Coord_Y[11:0];
    end
end

// matlab 测试数据
wire                   [  11:0]         matlab_X,matlab_Y          ;
assign matlab_X = (VGA_X < COL) ? VGA_X + 1'b1 : 1'b0;
assign matlab_Y = (VGA_Y < ROW) ? VGA_Y + 1'b1 : 1'b0;

endmodule