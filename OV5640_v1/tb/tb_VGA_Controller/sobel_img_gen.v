// task rx_byte();
//     integer j;
//     for (j=0; j<16384; j=j+1)
//         rx_bit(data_men[j]);
// endtask

//~ `New testbench
`timescale  1ns / 1ps

module sobel_img_gen(
    output wire                         VGA_HS                     ,
    output wire                         VGA_VS                     ,
    output wire                         o_sobel_data                // 1位的sobel数据
);



    parameter                           SYS_PERIOD = 20            ;// 系统时钟
    parameter                           VGA_PERIOD = 25            ;// VGA时钟
    parameter                           ROW        = 30            ;
    parameter                           COL        = 30            ;

// sys input
reg                                     rst_n                  = 0 ;
reg                                     sys_clk                = 0 ;
reg                                     vga_clk                = 0 ;

// reg 
reg                                     data_men[ROW*COL - 1:0]    ;//128*128=16384


// color_bar Inputs
reg                    [   9:0]         iRed                   = 0 ;
reg                    [   9:0]         iGreen                 = 0 ;
reg                    [   9:0]         iBlue                  = 0 ;

// color_bar Inputs
wire                   [  11:0]         Coord_X                    ;
wire                   [  11:0]         Coord_Y                    ;
// color_bar Outputs
wire                   [   4:0]         oVGA_R                     ;
wire                   [   5:0]         oVGA_G                     ;
wire                   [   4:0]         oVGA_B                     ;
wire                                    oVGA_H_SYNC                ;
wire                                    oVGA_V_SYNC                ;
wire                                    oVGA_DE                    ;

// assign
assign o_sobel_data = (oVGA_R[0] == 1'b1) ? 1'b1 : 1'b0;            // 只要color_bar的oVGA_R有一位输出为1, 那么就为1
assign VGA_HS = oVGA_H_SYNC;
assign VGA_VS = oVGA_V_SYNC;

// init men
initial begin
    $readmemh("../../../matlab/OV5640/img/img.txt", data_men);
end

// sys_clk
initial begin
    forever #(SYS_PERIOD/2)  sys_clk=~sys_clk;
end

// vga_clk
initial begin
    forever #(VGA_PERIOD/2)  vga_clk=~vga_clk;
end

// rst_n
initial begin
    #(SYS_PERIOD*2) rst_n  =  0;
end

// sobel_data
always @(*) begin
    if(data_men[Coord_X+Coord_Y*COL] == 1'b1)begin
        iRed   = 10'b11_1111_1111;
        iGreen = 10'b11_1111_1111;
        iBlue  = 10'b11_1111_1111;
    end
    else begin
        iRed   = 10'b00_0000_0000;
        iGreen = 10'b00_0000_0000;
        iBlue  = 10'b00_0000_0000;
    end
end

// end time
initial begin
    #50_000_000;
    $stop;
end

// inst color_bar
color_bar u_color_bar (
    // input
    .iRed                              (iRed         [   9:0]     ),
    .iGreen                            (iGreen       [   9:0]     ),
    .iBlue                             (iBlue        [   9:0]     ),
    .iCLK                              (vga_clk                   ),
    .rst                               (~rst_n                    ),
    // output
    .oCoord_X                          (Coord_X                   ),
    .oCoord_Y                          (Coord_Y                   ),
    .oVGA_R                            (oVGA_R       [   4:0]     ),
    .oVGA_G                            (oVGA_G       [   5:0]     ),
    .oVGA_B                            (oVGA_B       [   4:0]     ),
    .oVGA_H_SYNC                       (oVGA_H_SYNC               ),
    .oVGA_V_SYNC                       (oVGA_V_SYNC               ),
    .oVGA_SYNC                         (                          ),// useless, always 0
    .oVGA_BLANK                        (                          ),// = oVGA_H_SYNC & oVGA_V_SYNC;
    .oVGA_CLOCK                        (                          ),// uesless, assign oVGA_CLOCK =	iCLK;
    .oVGA_DE                           (oVGA_DE                   ),// = h_active & v_active
    .oVGA_DE_r                         (                          ) // oVGA_DE delays 1 iCLK
);


endmodule