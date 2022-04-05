/**
可以删掉的测试文件
*/

module vga_test (
    ////////////////////////	SYS Input	 	////////////////////////
    input  wire                         CLOCK_50                   ,//	50 MHz
    input  wire                         RST_N                      ,
    ////////////////////////	VGA			////////////////////////////
    output wire                         VGA_HS                     ,//	VGA H_SYNC
    output wire                         VGA_VS                     ,//	VGA V_SYNC
    output wire        [   4:0]         VGA_R                      ,//	VGA Red[9:0]
    output wire        [   5:0]         VGA_G                      ,//	VGA Green[9:0]
    output wire        [   4:0]         VGA_B                       //	VGA Blue[9:0]
);

//-----------------------------------------------------------------
wire                                    VGA_CTRL_CLK               ;
clock_pll u_clok_pll (
    .inclk0                            (CLOCK_50                  ),//50MHz
    .areset                            (~RST_N                    ),
    .locked                            (                          ),
    .c0                                (VGA_CTRL_CLK              ),//25MHz
    .c1                                (                          ) //24MHz
);

//-----------------------------------------------------------------
wire                                    initial_en                 ;
Reset_Delay u_Reset_Delay (
    .iCLK                              (CLOCK_50                  ),
    .iRST                              (RST_N                     ),
    .oRST_0                            (                          ),
    .oRST_1                            (                          ),
    .oRST_2                            (                          ),
    .oRST_3                            (initial_en                ) 
);

//-----------------------------------------------------------------
color_bar u_color_bar (
    //	Host Side
    .iRed                              (10'b10_1010_1010          ),
    .iGreen                            (10'b01_0101_0101          ),
    .iBlue                             (10'b11_0011_0011          ),
    .oCoord_X                          (                          ),
    .oCoord_Y                          (                          ),
	//	VGA Side
    .oVGA_R                            (VGA_R                     ),
    .oVGA_G                            (VGA_G                     ),
    .oVGA_B                            (VGA_B                     ),
    .oVGA_H_SYNC                       (VGA_HS                    ),
    .oVGA_V_SYNC                       (VGA_VS                    ),
    .oVGA_SYNC                         (                          ),
    .oVGA_BLANK                        (                          ),
    .oVGA_CLOCK                        (                          ),
    .oVGA_DE                           (                          ),
	//	Control Signal
    .iCLK                              (VGA_CTRL_CLK              ),
    .rst                               (~initial_en               ) 
);

endmodule
